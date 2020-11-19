//
//  File.swift
//  
//
//  Created by Jose Deyvid on 20/10/20.
//

import Foundation
import Vapor
import Fluent

class UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        //users
        let users = routes.grouped(UserRoutes.getPathComponent(.main))
        
        users.on(.POST, body: .collect(maxSize: "20mb")) { (req) in
            try self.createAdmin(req: req)
        }
        
        //users/:tokenId
        users.group(UserRoutes.getPathComponent(.employeeToken)) { (createEmployee) in
            createEmployee.on(.POST, body: .collect(maxSize: "20mb")) { req in
                try self.createEmployee(req: req)
            }
        }
        
        let tokenProtected = users.grouped(UserToken.authenticator()).grouped(UserToken.guardMiddleware())
        
        tokenProtected.get(use: fetchAllUsers)

        //users/:userId
        tokenProtected.group(UserRoutes.getPathComponent(.id)) { (user) in
            user.get(use: fetchUserById)
            user.delete(use: deleteUserById)
            user.put(use: updateUserById)
        }
    }
    
    func createAdmin(req: Request) throws -> EventLoopFuture<LoginPackage> {
        let user = try req.content.decode(User.self)
        let userResponse = UserResponse(id: user.id!, name: user.name, email: user.email, password: user.password, isAdmin: user.isAdmin, image: user.image, teamId: user.$team.id)
        let token = try user.generateToken()
        
        return user.save(on: req.db).flatMap { _ -> EventLoopFuture<LoginPackage> in
            let response = LoginPackage(user: userResponse, userToken: token)
            return token.save(on: req.db).transform(to: response)
        }
    }
    
    func createEmployee(req: Request) throws -> EventLoopFuture<LoginPackage> {
        guard let employeeToken = req.parameters.get(UserParameters.employeeToken.rawValue) else {
            throw Abort(.notFound)
        }
        
        let promise = req.eventLoop.makePromise(of: LoginPackage.self)
        
        return Team.query(on: req.db)
            .filter(\.$employeeToken == employeeToken)
            .first()
            .unwrap(or: Abort(.unauthorized, reason: "Token de Acesso Inválido"))
            .flatMapThrowing { (optionalTeam) -> User in
                let team = Team(id: optionalTeam.id, name: optionalTeam.name, description: optionalTeam.description, image: optionalTeam.image, employeeToken: optionalTeam.employeeToken, guestToken: optionalTeam.guestToken,activeUsers: [])
                
                let user = try req.content.decode(User.self)
                user.$team.id = team.id!
                return user
            }.flatMap { (user) in
                do {
                    let userResponse = UserResponse(id: user.id!, name: user.name, email: user.email, password: user.password, isAdmin: user.isAdmin, image: user.image, teamId: user.$team.id)
                    let token = try user.generateToken()
                    user.save(on: req.db).whenSuccess {
                        let response = LoginPackage(user: userResponse, userToken: token)
                        token.save(on: req.db).whenSuccess { _ in
                            promise.succeed(response)
                        }
                    }
                } catch {
                    promise.fail(Abort(.badRequest))
                }
                return promise.futureResult
            }
    }
    
    func fetchAllUsers(req: Request) throws -> EventLoopFuture<[UserResponse]>  {
        
        return User.query(on: req.db).all().map { (users) in
            var usersResponse = [UserResponse]()
            users.forEach { (user) in
                usersResponse.append(UserResponse(id: user.id!,
                                                  name: user.name,
                                                  email: user.email,
                                                  password: user.password,
                                                  isAdmin: user.isAdmin,
                                                  image: user.image,
                                                  teamId: user.$team.id))
            }
            return usersResponse
        }
    }
    
    func fetchUserById(req: Request) throws -> EventLoopFuture<User> {
        
        
        return User.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteUserById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        
        
        return User.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    func updateUserById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        
        
        let newUser = try req.content.decode(AuthEntity.self)
        return User.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (user) in
                user.email = newUser.email
                return user.update(on: req.db).transform(to: .ok)
            }
    }
    
}

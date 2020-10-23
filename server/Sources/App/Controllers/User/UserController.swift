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
        users.post(use: createAdmin)
        users.get(use: fetchAllUsers)
        
        users.group(UserRoutes.getPathComponent(.employeeToken)) { (token) in
            token.post(use: createEmployee)
        }

        //users/:userId
        users.group(UserRoutes.getPathComponent(.id)) { (user) in
            user.get(use: fetchUserById)
            user.delete(use: deleteUserById)
            user.put(use: updateUserById)
        }
    }

    func createAdmin(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map {user}
    }
    
    func createEmployee(req: Request) throws -> EventLoopFuture<User> {
        guard let employeeToken = req.parameters.get(UserParameters.employeeToken.rawValue) else {
            throw Abort(.notFound)
        }
        
        return Team.query(on: req.db)
            .filter(\.$employeeToken == employeeToken)
            .first()
            .unwrap(or: Abort(.unauthorized, reason: "Token de Acesso Inválido"))
            .flatMapThrowing { (optionalTeam) -> User in
                let team = Team(id: optionalTeam.id, name: optionalTeam.name, description: optionalTeam.description, image: optionalTeam.image, employeeToken: optionalTeam.employeeToken, guestToken: optionalTeam.guestToken)
                
                let user = try req.content.decode(User.self)
                user.$team.id = team.id!
                return user
            }.flatMap { (user) in
                return user.save(on: req.db).transform(to: user)
            }
    }
    
    func fetchAllUsers(req: Request) throws -> EventLoopFuture<[User]>  {
        return User.query(on: req.db).all()
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
                   user.name = newUser.name
                   user.email = newUser.email
                   return user.update(on: req.db).transform(to: .ok)
           }
       }

}

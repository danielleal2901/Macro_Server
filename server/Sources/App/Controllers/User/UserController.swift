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
        
        users.get(use: fetchAllUsers)

        //users/:userId
        users.group(UserRoutes.getPathComponent(.id)) { (user) in
            user.get(use: fetchUserById)
            user.delete(use: deleteUserById)
            user.put(use: updateUserById)
        }
    }

    
    
    func fetchAllUsers(req: Request) throws -> EventLoopFuture<[UserResponse]>  {
        try req.auth.require(User.self)
        
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
        try req.auth.require(User.self)
        
        return User.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteUserById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        try req.auth.require(User.self)

        return User.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    func updateUserById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        try req.auth.require(User.self)

        let newUser = try req.content.decode(AuthEntity.self)
        return User.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db)
               .unwrap(or: Abort(.notFound))
               .flatMap { (user) in
                   user.email = newUser.email
                   return user.update(on: req.db).transform(to: .ok)
           }
       }

}

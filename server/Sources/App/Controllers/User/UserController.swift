//
//  File.swift
//  
//
//  Created by Jose Deyvid on 20/10/20.
//

import Foundation
import Vapor

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

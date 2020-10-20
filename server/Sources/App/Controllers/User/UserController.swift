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
        }
    }

    func fetchAllUsers(req: Request) throws -> EventLoopFuture<[User]>  {
        return User.query(on: req.db).all()
    }

    func fetchUserById(req: Request) throws -> EventLoopFuture<User> {
        return User.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

}

//
//  File.swift
//
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Fluent
import Vapor

struct CreateUser: Migration {
    var name: String { "CreateUser" }

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}

//
//  File.swift
//
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Fluent
import Vapor

struct CreateUser: Migration {    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("is_admin", .bool, .required)
            .field("image", .data, .required)
            .field("team_id", .uuid, .required)
            .foreignKey("team_id", references: "teams", "id", onDelete: .cascade, onUpdate: .restrict)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}

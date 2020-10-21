//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Fluent
import Vapor

class CreateUserToken: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_tokens")
            .id()
            .field("value", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .unique(on: "value")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_tokens").delete()
    }
}


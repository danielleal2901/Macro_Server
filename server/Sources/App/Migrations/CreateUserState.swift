//
//  CreateUserState.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 01/10/20.
//

import Fluent
import Vapor

struct CreateUserState: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users_states")
            .id()
            .field("respUserID", .uuid, .required)
            .field("destTeamID", .uuid, .required)
            .field("stageID", .uuid, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}

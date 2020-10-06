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
        
        return database.enum("stages_types").read().flatMap { stageType in
            database.schema("users_states")
                .id()
                .field("name", .string)
                .field("photo", .string)
                .field("respUserID", .uuid, .required)
                .field("terrainID", .uuid, .required)
                .field("stageType",stageType,.required)
                .field("destTeamID", .uuid, .required)
                .foreignKey("respUserID", references: "users","id")
                .foreignKey("terrainID", references: "terrains","id")
                .create()
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}

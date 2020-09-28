//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateStage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.enum("stages_types").read().flatMap { stageType in
            database.schema("stages")
                .id()
                .field("type", stageType, .required)
                .field("terrain_id", .uuid, .required)
                .foreignKey("terrain_id", references: "terrains", "id", onDelete: .cascade, onUpdate: .restrict)
                .create()
        }
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("stages").delete()
    }
    
}

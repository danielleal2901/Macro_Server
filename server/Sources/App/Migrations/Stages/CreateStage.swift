//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateStage: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.enum("stages_types").read().flatMap { stageType in
            database.schema("stages")
                .id()
                .field("container_id", .uuid, .required)
                .foreignKey("container_id", references: "stagesContainer", "id", onDelete: .cascade, onUpdate: .restrict)
                .field("type", stageType, .required)
                .create()
        }
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("stages_types").delete()
    }
    
}

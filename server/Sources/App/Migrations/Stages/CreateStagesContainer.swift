//
//  File.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateStagesContainer: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.enum("stagesContainers_types").read().flatMap { containerType in
            database.schema("stagesContainer")
                .id()
                .field("farm_id", .uuid, .required)
                .foreignKey("farm_id", references: "farms", "id", onDelete: .cascade, onUpdate: .restrict)
                .field("type", containerType, .required)
                .field("stages_names", .array(of: .string), .required)
                .create()
        }

    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("stagesContainer").delete()
    }
    
}

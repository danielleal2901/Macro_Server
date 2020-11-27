//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/10/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateFarm: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.schema("farms")
            .id()
            .field("name", .string, .required)
            .field("teamId", .uuid, .required)
            .foreignKey("teamId", references: "teams", "id", onDelete: .cascade, onUpdate: .restrict)
            .field("desc",.string)
            .field("icon", .data, .required)
            .create()
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("farms").delete()
    }
    
}

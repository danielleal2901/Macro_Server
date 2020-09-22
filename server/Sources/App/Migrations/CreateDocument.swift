//
//  File.swift
//  
//
//  Created by Jose Deyvid on 21/09/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateDocument: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("documents")
            .id()
            .field("format", .string, .required)
            .field("stage_id", .uuid, .required)
            .foreignKey("stage_id", references: "stages", "id", onDelete: .cascade)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("documents").delete()
    }
    
}

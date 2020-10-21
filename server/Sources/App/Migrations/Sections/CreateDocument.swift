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
            .field("stage_id", .uuid, .required)
            .unique(on: "stage_id")
            .foreignKey("stage_id", references: "stages", "id", onDelete: .cascade, onUpdate: .restrict)
            .field("sections", .array(of: .array(of: .custom(DocumentSection.self)) ), .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("documents").delete()
    }
    
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 05/10/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateFiles: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("files")
            .id()
            .field("document_id", .uuid, .required)
            .field("item_id", .uuid, .required)
            .field("data", .data, .required)
            .foreignKey("document_id", references: "documents", "id", onDelete: .cascade, onUpdate: .restrict)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("files").delete()
    }
    
}

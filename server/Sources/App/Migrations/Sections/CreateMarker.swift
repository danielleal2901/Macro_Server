//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 06/11/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateMarker: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("markers")
            .id()
            .field("title", .string, .required)
            .field("color", .array(of: .double), .required)
            .field("isSelected", .bool, .required)
            .field("status_id", .uuid,.required)
            .foreignKey("status_id", references: "status", "id", onDelete: .cascade)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("markers").delete()
    }
    
}

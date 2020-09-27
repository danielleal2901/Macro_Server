////
////  File.swift
////
////
////  Created by Daniel Leal on 24/09/20.
////
//
import Foundation
import Fluent
import FluentPostgresDriver

struct CreateStatus: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.schema("status")
            .id()
            .field("stage_id", .uuid, .required)
            .unique(on: "stage_id")
            .foreignKey("stage_id", references: "stages", "id", onDelete: .cascade, onUpdate: .restrict)
            .field("sections", .array(of: .array(of: .custom(StatusSection.self)) ), .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("status").delete()
    }
        
}

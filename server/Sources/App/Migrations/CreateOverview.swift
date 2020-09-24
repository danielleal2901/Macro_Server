////
////  File.swift
////
////
////  Created by Daniel Leal on 20/09/20.
////
//
import Foundation
import Fluent
import FluentPostgresDriver

struct CreateOverview: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.schema("overviews")
            .id()
            .field("stage_id", .uuid, .required, .references("stages", "id"))
            .field("sections", .array(of: .array(of: .string)), .required)
            .create()
            
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("overviews").delete()
    }
        
}

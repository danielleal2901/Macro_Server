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
            .field("desc",.string)
            .unique(on: "name")
            .create()
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("farms").delete()
    }
    
}

//
//  File.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateTerrain: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("terrains")
            .id()
            .field("name", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("terrains").delete()
    }
    
}

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
        
        return database.schema("terrains")
            .id()
            .field("name", .string)
            .field("stages_names", .array(of: .string), .required)
            .create()
        
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("terrains").delete()
    }
    
}

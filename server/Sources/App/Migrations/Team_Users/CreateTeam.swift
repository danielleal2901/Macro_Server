//
//  File.swift
//  
//
//  Created by Antonio Carlos on 19/10/20.
//

import Fluent
import Vapor

struct CreateTeam: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("teams")
            .id()
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("image", .data, .required)
            .field("employee_token", .string, .required)
            .field("guest_token", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("teams").delete()
    }
    
}

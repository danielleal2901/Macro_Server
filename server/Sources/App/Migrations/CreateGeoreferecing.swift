//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateGeoreferecing: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("georeferecings")
            .id()
            .field("terrain_id", .uuid, .required, .references("terrains", "id"))
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("georeferecings").delete()
    }
}

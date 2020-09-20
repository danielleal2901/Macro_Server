//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateOverview: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("overviews")
            .id()
            .field("geo_id", .uuid, .required, .references("georeferecings", "id"))
            .field("sections", ., .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("georeferecings").delete()
    }
}

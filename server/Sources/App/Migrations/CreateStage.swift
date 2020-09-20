//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateStage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.enum("stage_type")
            .case("georeferecing")
            .case("car")
            .case("avaliation")
            .case("enviromental")
            .case("registryIndividualization")
            .case("residentData")
            .create().flatMap { _ in _
                database.enum("stage_type").read().flatMap { stageType in
                    database.schema("stages")
                        .id()
                        .field("type", stageType, .required)
                        .field("terrain_id", .uuid, .required, .references("terrains", "id"))
                        .field("name", .string, .required)
                        .create()
                }
            }

    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("stages").delete()
    }
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//


import Foundation
import Fluent
import FluentPostgresDriver

struct CreateEnum: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("stages_types")
        .case("georeferencing")
        .case("car")
        .case("evaluation")
        .case("enviroment")
        .case("register")
        .case("resident")
            .create().transform(to: ())
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("stageTypes").delete()
    }
}

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
        return database.enum("stagetypes")
        .case("georeferecing")
        .case("car")
        .case("avaliation")
        .case("enviromental")
        .case("registryIndividualization")
        .case("residentData")
            .create().transform(to: ())
        
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("georeferecings").delete()
    }
}

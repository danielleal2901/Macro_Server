//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/10/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateStagesContainersTypesEnum: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("stagesContainers_types")
        .case("terrain")
        .case("stage")
        .case("territorialDiagnosis")
        .case("socialMobilization")
        .case("descriptiveMemorial")
        .case("environmentalStudy")
            .create().transform(to: ())
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
         return database.schema("stagesContainers_types").delete()
    }
}

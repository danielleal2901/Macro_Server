//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//


import Foundation
import Fluent
import FluentPostgresDriver

struct CreateStageTypesEnum: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("stages_types")
        .case("diagnosticData")
        .case("documentaryResearch")
        .case("landResearch")
        .case("territorialStudy")
        .case("finalReport")
        .case("workPlan")
        .case("socialMobilizationData")
        .case("environmentalStudyData")
        .case("descriptiveMemorialData")
        .case("territorialSurvey")
        .case("propertyRegistration")
        .case("socioeconomicRegistration")
        .case("propertyEvaluation")
        .case("terrainData")
        .case("georeferencing")
        .case("car")
        .case("evaluation")
        .case("environment")
        .case("register")
        .case("resident")
            .create().transform(to: ())
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("stages_types").delete()
    }
}

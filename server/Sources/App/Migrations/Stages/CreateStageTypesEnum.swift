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
        .case("diagnosticDocumentaryResearch")
        .case("diagnosticLandResearch")
        .case("diagnosticTerritorialStudy")
        .case("diagnosticFinalReport")
        .case("diagnosticWorkPlan")
        .case("socialMobilizationData")
        .case("environmentalStudyData")
        .case("descriptiveMemorialData")
        .case("descriptiveMemorialGeoreferencing")
        .case("descriptiveMemorialTerritorialSurvey")
        .case("descriptiveMemorialPropertyRegistration")
        .case("descriptiveMemorialSocioeconomicRegistration")
        .case("descriptiveMemorialPropertyEvaluation")
        .case("terrainData")
        .case("terrainGeoreferencing")
        .case("terrainCar")
        .case("terrainEvaluation")
        .case("terrainEnvironment")
        .case("terrainResident")
            .create().transform(to: ())
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.enum("stages_types").delete()
    }
}

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
            .case("diagnosticMain")
            .case("diagnosticDocumentaryResearch")
            .case("diagnosticLandResearch")
            .case("diagnosticTerritorialStudy")
            .case("diagnosticWorkPlan")
            .case("diagnosticFinalReport")
            
            
            .case("socialMobilizationMain")
            .case("socialMobilizationSocialLicense")
            .case("socialMobilizationFollowUpGroup")
            .case("socialMobilizationSocialEngaging")
            
            .case("environmentalStudyMain")
            .case("environmentalEnvironmentalLicense")
            .case("environmentalTechnicalReport")
            
            .case("descriptiveMemorialMain")
            .case("descriptiveMemorialGeoreferencing")
            .case("descriptiveMemorialTerritorialSurvey")
            .case("descriptiveMemorialPropertyRegistration")
            .case("descriptiveMemorialSocioeconomicRegistration")
            .case("descriptiveMemorialPropertyEvaluation")
            
            .case("terrainMain")
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

//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor

enum StageTypes: String, Content{
    
    //Diagnosticc
    case diagnosticMain
    case diagnosticDocumentaryResearch
    case diagnosticLandResearch
    case diagnosticTerritorialStudy
    case diagnosticWorkPlan
    case diagnosticFinalReport
    
    //SocialMob
    case socialMobilizationMain
    case socialMobilizationSocialLicense
    case socialMobilizationFollowUpGroup
    case socialMobilizationSocialEngaging
    
    //EnvironmentalStudy
    case environmentalStudyMain
    case environmentalEnvironmentalLicense
    case environmentalTechnicalReport
    
    //DescriptiveMemorial
    case descriptiveMemorialMain
    case descriptiveMemorialGeoreferencing
    case descriptiveMemorialTerritorialSurvey
    case descriptiveMemorialPropertyRegistration
    case descriptiveMemorialSocioeconomicRegistration
    case descriptiveMemorialPropertyEvaluation
    
    //Terrain
    case terrainMain
    case terrainGeoreferencing
    case terrainCar
    case terrainEvaluation
    case terrainEnvironment
    case terrainResident
    
}


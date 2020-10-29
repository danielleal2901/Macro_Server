//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor

enum StageTypes : String, Content{
    
    //Diagnosticc
    case diagnosticData
    case diagnosticDocumentaryResearch
    case diagnosticLandResearch
    case diagnosticTerritorialStudy
    case diagnosticFinalReport
    case diagnosticWorkPlan
    
    //SocialMob
    case socialMobilizationData
    
    //EnvironmentalStudy
    case environmentalStudyData
    
    //DescriptiveMemorial
    case descriptiveMemorialData
    case descriptiveMemorialGeoreferencing
    case descriptiveMemorialTerritorialSurvey
    case descriptiveMemorialPropertyRegistration
    case descriptiveMemorialSocioeconomicRegistration
    case descriptiveMemorialPropertyEvaluation
    
    //Terrain
    case terrainData
    case terrainGeoreferencing
    case terrainCar
    case terrainEvaluation
    case terrainEnvironment
    case terrainResident
    
    
}


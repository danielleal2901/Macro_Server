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
    case documentaryResearch
    case landResearch
    case territorialStudy
    case finalReport
    case workPlan
    
    //SocialMob
    case socialMobilizationData
    
    //Environmental
    case environmentalStudyData
    
    //DescriptiveMemorial
    case descriptiveMemorialData
    case georeferencing
    case territorialSurvey
    case propertyRegistration
    case socioeconomicRegistration
    case propertyEvaluation
    
    //Terrain
    case terrainData
    case car
    case evaluation
    case environment
    case register
    case resident
    
    
}


//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor

enum StageRoute : String {
    case main = "stages"
    case stageName = ":stageName"
    case stageId = ":stageId"
    case withTerrain = "terrain"
    case terrainId = ":terrainId"
}

enum StageParameters: String {
    case stageName = "stageName"
    case stageId = "stageId"
    case terrainId = "terrainId"
}

    


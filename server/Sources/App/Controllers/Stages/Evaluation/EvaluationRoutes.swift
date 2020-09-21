//
//  File 2.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Vapor

enum EvaluationRoutes: String, PathComponents {
    case main = "Evaluationreferecings"
    case id = ":EvaluationId"
    case withTerrain = "terrain"
    case terrainId = ":terrainId"
    
    var getPath : PathComponent{
        return PathComponent(stringLiteral: self.rawValue)
    }
}

enum EvaluationParameters : String {
    case EvaluationId = "EvaluationId"
    case terrainId = "terrainId"
}

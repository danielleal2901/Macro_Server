//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 09/11/20.
//


import Foundation
import Vapor

enum MarkerRoutes: String{
    case main = "markers"
    case id = ":markerId"
    case teamId = ":stageId"
    
    static func getPathComponent(_ route: FarmRoutes) -> PathComponent{
        return PathComponent(stringLiteral: route.rawValue)
    }
    
}



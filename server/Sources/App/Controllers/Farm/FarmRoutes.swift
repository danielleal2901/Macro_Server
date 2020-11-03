//
//  File.swift
//
//
//  Created by Guilherme Martins Dalosto de Oliveira on 22/10/20.
//

import Foundation
import Vapor

enum FarmRoutes: String{
    case main = "farms"
    case id = ":farmId"
    case team = "team"
    case teamId = ":teamId"
    
    static func getPathComponent(_ route: FarmRoutes) -> PathComponent{
        return PathComponent(stringLiteral: route.rawValue)
    }
    
}

enum FarmParameters: String{
    case idFarm = "farmId"
    case teamId = "teamId"
}


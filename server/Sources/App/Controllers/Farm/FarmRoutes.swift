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
    case id = ":farmID"
    
    static func getPathComponent(_ route: FarmRoutes) -> PathComponent{
        return PathComponent(stringLiteral: route.rawValue)
    }
    
}

enum FarmParameters: String{
    case idFarm = "farmId"
}


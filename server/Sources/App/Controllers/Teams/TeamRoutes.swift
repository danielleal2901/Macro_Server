//
//  File.swift
//  
//
//  Created by Antonio Carlos on 16/10/20.
//

import Foundation
import Vapor

enum TeamRoutes: String {
    case main = "teams"
    case id = ":teamID"
    
    static func getPathComponent(_ route: TeamRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum TeamParameters: String {
    case teamId = "teamID"
}

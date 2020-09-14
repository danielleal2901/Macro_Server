//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Vapor

enum GeoRoutes: String {
    case main = "georeferecings"
    case id = ":geo"
    
    static func getPathComponent(_ route: GeoRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

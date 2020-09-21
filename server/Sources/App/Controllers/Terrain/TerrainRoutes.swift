//
//  File.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Vapor

enum TerrainRoutes: String {
    case main = "terrains"
    case id = ":terrainID"
    
    static func getPathComponent(_ route: TerrainRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum TerrainParameters: String {
    case idTerrain = "terrainID"
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Vapor

enum GeoRoutes: String, PathComponents {
    case main = "georeferecings"
    case id = ":geoId"
    case withTerrain = "terrain"
    case terrainId = ":terrainId"
    
    var getPath : PathComponent{
        return PathComponent(stringLiteral: self.rawValue)
    }
}

enum GeoParameters : String {
    case geoId = "geoId"
    case terrainId = "terrainId"
}

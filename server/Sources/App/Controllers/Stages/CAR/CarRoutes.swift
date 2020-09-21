//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Vapor

enum CarRoutes: String {
    case main = "Carreferecings"
    case id = ":CarId"
    case withTerrain = "terrain"
    case terrainId = ":terrainId"
}

enum CarParameters : String {
    case CarId = "CarId"
    case terrainId = "terrainId"
}

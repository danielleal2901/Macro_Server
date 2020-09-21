//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Vapor

enum EnviromentRoutes: String, PathComponents {
    case main = "Enviromentreferecings"
    case id = ":EnviromentId"
    case withTerrain = "terrain"
    case terrainId = ":terrainId"
    
//    func getPathComponent(_ route: EnviromentRoutes) -> PathComponent {
//        return PathComponent(stringLiteral: route.rawValue)
//    }
    
    var getPath : PathComponent{
        return PathComponent(stringLiteral: self.rawValue)
    }
}

enum EnviromentParameters : String {
    case enviromentId = "EnviromentId"
    case terrainId = "terrainId"
}

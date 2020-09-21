//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor

protocol PathComponents {
    var getPath: PathComponent {get}
}


    
struct StageRoutes {
    
    struct Route {
        var main: String
        var id: String
        var withTerrain = "terrain"
        var terranId = ":terrainId"
    }
    
    enum StageType {
        case geo
        case enviromental
        case evaluation
        case car
        case registry
        case resident
    }
    
    var stage: StageType
    var route: Route {
        switch self.stage {
        case .geo:
            return Route(main: "georeferecings", id: ":geoId")
        case .enviromental:
            return Route(main: "georeferecings", id: ":geoId")
        default:
            
        }
    }
}
    
    


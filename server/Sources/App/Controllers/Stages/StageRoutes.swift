//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor

struct StageRoutes {
    struct Route {
        var main: String
        var id: String
        var withTerrain = "terrain"
        var terrainId = ":terrainId"
        var parameters: Parameters
    }
    
    struct Parameters {
        var stageId: String
        var terrainId = "terrainId"
    }
    
    var stage: StageTypes
    var route: Route {
        switch self.stage {
        case .georeferecing:
            return Route(main: "georeferecings", id: ":geoId", parameters: Parameters(stageId: "geoId"))
        case .enviroment:
            return Route(main: "enviroments", id: ":enviromentId", parameters: Parameters(stageId: "enviromentId"))
        case .car:
            return Route(main: "cars", id: ":carId", parameters: Parameters(stageId: "carId"))
        case .evaluation:
            return Route(main: "evaluations", id: ":evaluationId", parameters: Parameters(stageId: "evaluationId"))
        case .register:
            return Route(main: "registers", id: ":register", parameters: Parameters(stageId: "registerId"))
        case .resident:
            return Route(main: "residents", id: ":residentId", parameters: Parameters(stageId: "residentId"))
        }
    }

}
    
    


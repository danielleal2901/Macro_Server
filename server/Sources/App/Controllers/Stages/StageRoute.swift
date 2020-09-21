//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor

enum StageRoute : String {
    case main = "stages"
    case stageName = ":stageName"
    case stageId = ":stageId"
    case withTerrain = "terrain"
    case terrainId = ":terrainId"
}

enum StageParameters: String {
    case stageName = "stageName"
    case stageId = "stageId"
    case terrainId = "terrainId"
}
    
//    var stage: StageTypes
//    var route: Route {
//        switch self.stage {
//            default:
//                return Route(stageName: "georeferecings", stageId: ":geoId", parameters: Parameters(stageName: "georeferecings", stageId: "geoId"))
////        case .georeferecing:
////            return Route(main: "georeferecings", id: ":geoId", parameters: Parameters(stageId: "geoId"))
////        case .enviroment:
////            return Route(main: "enviroments", id: ":enviromentId", parameters: Parameters(stageId: "enviromentId"))
////        case .car:
////            return Route(main: "cars", id: ":carId", parameters: Parameters(stageId: "carId"))
////        case .evaluation:
////            return Route(main: "evaluations", id: ":evaluationId", parameters: Parameters(stageId: "evaluationId"))
////        case .register:
////            return Route(main: "registers", id: ":register", parameters: Parameters(stageId: "registerId"))
////        case .resident:
////            return Route(main: "residents", id: ":residentId", parameters: Parameters(stageId: "residentId"))
//        }
//    }
//
//}
    
    


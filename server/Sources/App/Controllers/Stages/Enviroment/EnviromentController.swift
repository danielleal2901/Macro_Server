//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

class EnviromentController: RouteCollection, StageRoutesProtocol {
    func boot(routes: RoutesBuilder) throws {
//        let enviroment = routes.grouped(EnviromentRoutes.getPathComponent(.main))
//        enviroment.post(use: insertStage)
//        enviroment.get(use: fetchAllStages)
//        //With EnviromentID
//        enviroment.group(EnviromentRoutes.getPathComponent(.id)) { (enviroment) in
//            enviroment.delete(use: deleteStageById)
//            enviroment.get(use: fetchStageById)
//            enviroment.put(use: updateStageById)
//        }
//        //With terrainID
//        enviroment.group(EnviromentRoutes.getPathComponent(.withTerrain)) { (enviroment) in
//            enviroment.group(EnviromentRoutes.getPathComponent(.terrainId)) { (enviroment) in
//                enviroment.get(use: fetchEnviromentByTerrainID)
//            }
//        }
    }
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

class EvaluationController: RouteCollection, StageRoutesProtocol {

    func boot(routes: RoutesBuilder) throws {
//        let evaluation = routes.grouped(EvaluationRoutes.getPathComponent(.main))
//        evaluation.post(use: insertEvaluationreferecing)
//        evaluation.get(use: fetchAllEvaluation)
//        //With EvaluationID
//        evaluation.group(EvaluationRoutes.getPathComponent(.id)) { (evaluation) in
//            evaluation.delete(use: deleteEvaluationById)
//            evaluation.get(use: fetchEvaluationById)
//            evaluation.put(use: updateEvaluationById)
//        }
//        //With terrainID
//        evaluation.group(EvaluationRoutes.getPathComponent(.withTerrain)) { (evaluation) in
//            evaluation.group(EvaluationRoutes.getPathComponent(.terrainId)) { (evaluation) in
//                evaluation.get(use: fetchEvaluationByTerrainID)
//            }
//        }
    }
}

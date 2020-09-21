//
//  File.swift
//  
//
//  Created by Daniel Leal on 21/09/20.
//

import Foundation
import Vapor
import Fluent

class StageController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        setupRoutesBuilder(routes: routes)
    }
    
    func setupRoutesBuilder(routes: RoutesBuilder){
        
        let stages = routes.grouped(PathComponent(stringLiteral: StageRoute.main.rawValue))
                
        stages.group(PathComponent(stringLiteral: StageRoute.stageName.rawValue)) { (stage) in
            stage.post(use: insertStage)
            stage.get(use: fetchAllStages)
            
            //With stageId
            stage.group(PathComponent(stringLiteral: StageRoute.stageId.rawValue)) { (stage) in
                stage.get(use: fetchStageById)
                stage.get(use: deleteStageById)
                
            }
            //With terrainID
            stage.group(PathComponent(stringLiteral: StageRoute.withTerrain.rawValue)) { (stage) in
                stage.group(PathComponent(stringLiteral: StageRoute.terrainId.rawValue)) { (stage) in
//                    stage.get(use: fetchStageByTerrainID)
                }
            }
            
            
        }

    }
    
    func insertStage(req: Request) throws -> EventLoopFuture<Stage.Output> {
                
        let stage = try StagesRoutesUtils.verifySimpleRoute(req: req)
        
        return stage.save(on: req.db)
            .map {Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)}
    }
    
    func fetchAllStages(req: Request) throws -> EventLoopFuture<[Stage.Output]> {

        let stage = try StagesRoutesUtils.verifySimpleRoute(req: req)

        return Stage.query(on: req.db)
            .filter(\.$type == stage.type)
            .all().map { stages in
                let outputs = stages.map { stage in
                    Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)
                }
                return outputs
        }
    }
    
    func fetchStageById(req: Request) throws -> EventLoopFuture<Stage.Output> {
        
        try StagesRoutesUtils.verifyRouteWithStageId(req: req)
        
        return Stage.find(req.parameters.get(StageParameters.stageId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing {
                
                //Valida se o a etapa informada na url eh a mesma que ira ser retornada no output.
                guard let parameterValue = req.parameters.get(StageParameters.stageName.rawValue, as: String.self),
                StageTypes(rawValue: parameterValue) == $0.type else {
                        throw Abort(.badRequest)
                }
                
               return Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString , stageType: $0.type.rawValue)
        }
    }
    
    func deleteStageById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        try StagesRoutesUtils.verifyRouteWithStageId(req: req)

        return Stage.find(req.parameters.get(StageParameters.stageId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing({
                //Valida se o a etapa informada na url eh a mesma que ira ser deletada.
                guard let parameterValue = req.parameters.get(StageParameters.stageName.rawValue, as: String.self),
                StageTypes(rawValue: parameterValue) == $0.type else {
                        throw Abort(.badRequest)
                }
                $0.delete(on: req.db)
            })
           return  .transform(to: .ok)
    }


    
    
}


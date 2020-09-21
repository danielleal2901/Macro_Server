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
    var stageRoute: StageRoute = StageRoute(parameters: Parameters())
    
    func boot(routes: RoutesBuilder) throws {
        setupRoutesBuilder(routes: routes)
    }
    
    func setupRoutesBuilder(routes: RoutesBuilder){
        
        let stages = routes.grouped(PathComponent(stringLiteral: stageRoute.main))
                
        stages.group(PathComponent(stringLiteral: stageRoute.stageName)) { (stage) in
            stage.post(use: insertStage)
            stage.get(use: fetchAllStages)
            
            //With stageId
            stage.group(PathComponent(stringLiteral: stageRoute.stageId)) { (stage) in
                stage.get(use: fetchStageById)
            }
            
            //With terrainID
            //        stage.group(PathComponent(stringLiteral: stageRoute.route.withTerrain)) { (stage) in
            //            stage.group(PathComponent(stringLiteral: stageRoute.route.terrainId)) { (stage) in
            //                stage.get(use: fetchStageByTerrainID)
            //            }
            //        }
        }

    }
    
    func insertStage(req: Request) throws -> EventLoopFuture<Stage.Output> {
        let verifyStagePath = try StagesRoutesUtils.verifyStageRequest(req: req)
                
        let input = try req.content.decode(Stage.Input.self)
        guard let id = UUID(uuidString: input.terrain) else {
            throw Abort(.badRequest)
        }
        
        guard let stageType = StageTypes(rawValue: input.stageType), verifyStagePath == stageType else {
            throw Abort(.badRequest)
        }
        
        let stage = Stage(type: stageType, terrainID: id)
        
        return stage.save(on: req.db)
            .map {Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)}
    }
    
    func fetchAllStages(req: Request) throws -> EventLoopFuture<[Stage.Output]> {

        let verifyStagePath = try StagesRoutesUtils.verifyStageRequest(req: req)

        return Stage.query(on: req.db)
            .filter(\.$type == verifyStagePath)
            .all().map { stages in
                let outputs = stages.map { stage in
                    Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)
                }
                return outputs
        }
    }
    
    func fetchStageById(req: Request) throws -> EventLoopFuture<Stage.Output> {

        let verifyStagePath = try StagesRoutesUtils.verifyStageRequest(req: req)
        
        return Stage.find(req.parameters.get(stageRoute.stageId), on: req.db)
            .unwrap(or: Abort(.notFound)).map {Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString , stageType: $0.type.rawValue)}
    }
    

    
    
}


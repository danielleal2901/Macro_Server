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
                stage.delete(use: deleteStageById)
                stage.put(use: updateStageById)
            }
            //With terrainID
            stage.group(PathComponent(stringLiteral: StageRoute.withTerrain.rawValue)) { (stage) in
                stage.group(PathComponent(stringLiteral: StageRoute.terrainId.rawValue)) { (stage) in
                    stage.get(use: fetchStageByTerrainID)
                }
            }
            
        }
        
    }
    
    func insertStage(req: Request) throws -> EventLoopFuture<Stage.Output> {
        
        let stageInput = try StagesRoutesUtils.verifyUploadRoutes(req: req)
        
        return Stage.query(on: req.db)
            .group(.and) { group in
                group.filter(\.$type == stageInput.type).filter("terrain_id", .equal, stageInput.$terrain.id)
        }.count().flatMapThrowing { count in
            if (count > 0) {
                throw Abort(.badRequest)
            }
        }.flatMap { _ in
            return stageInput.save(on: req.db).transform(to:Stage.Output(id: stageInput.id!.uuidString, terrain: stageInput.$terrain.id.uuidString, stageType: stageInput.type.rawValue))
        }
    
    }
    
    func fetchAllStages(req: Request) throws -> EventLoopFuture<[Stage.Output]> {
        
        let stageType = try StagesRoutesUtils.verifyDataRoutes(req: req)
        
        return Stage.query(on: req.db)
            .filter(\.$type == stageType)
            .all().map { stages in
                let outputs = stages.map { stage in
                    Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)
                }
                return outputs
        }
    }
    
    func fetchStageById(req: Request) throws -> EventLoopFuture<Stage.Output> {
        
        let stageType = try StagesRoutesUtils.verifyDataRoutes(req: req)
        
        return Stage.find(req.parameters.get(StageParameters.stageId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing {
                
                //Valida se o a etapa informada na url eh a mesma que ira ser retornada no output.
                if stageType != $0.type {
                    throw Abort(.badRequest)
                }
                
                return Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString , stageType: $0.type.rawValue)
        }
    }
    
    func deleteStageById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        let stageType = try StagesRoutesUtils.verifyDataRoutes(req: req)
        
        return Stage.find(req.parameters.get(StageParameters.stageId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing({
                
                //Valida se o a etapa informada na url eh a mesma que ira ser deletada.
                if stageType != $0.type {
                    throw Abort(.badRequest)
                }
                let _ = $0.delete(on: req.db)
            })
            .transform(to: .ok)
    }
    
    func updateStageById(req: Request) throws -> EventLoopFuture<Stage.Output> {
        
        let stageInput = try StagesRoutesUtils.verifyUploadRoutes(req: req)
        
        return Stage.find(req.parameters.get(StageParameters.stageId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { stage in
                
                //Valida se o a etapa informada na url eh a mesma que ira ser deletada.
                if stageInput.type != stage.type {
                    throw Abort(.badRequest)
                }
                
                //Colocar aqui o que quiser mudar
                let _ = stage.save(on: req.db)
                return Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString , stageType: stage.type.rawValue)
                
        }
    }
    
    func fetchStageByTerrainID(req: Request) throws -> EventLoopFuture<Stage.Output> {
        
        let stageType = try StagesRoutesUtils.verifyDataRoutes(req: req)
        
        guard let terrainId = req.parameters.get((StageParameters.terrainId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Stage.query(on: req.db)
            .filter("terrain_id", .equal, terrainId).first()
            .unwrap(or: Abort(.badRequest))
            .flatMapThrowing {
                if stageType != $0.type {
                    throw Abort(.badRequest)
                }
                return Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString, stageType: $0.type.rawValue)
        }
    }
    
    
}


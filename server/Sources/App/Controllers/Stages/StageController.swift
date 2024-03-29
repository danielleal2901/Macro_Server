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
        
        //stages
        let stages = routes.grouped(PathComponent(stringLiteral: StageRoute.main.rawValue))
        
        //stages/:stageName
        stages.group(PathComponent(stringLiteral: StageRoute.stageName.rawValue)) { (stage) in
            stage.get(use: fetchAllStages)
            
            //stages/:stageName/:stageId
            stage.group(PathComponent(stringLiteral: StageRoute.stageId.rawValue)) { (stage) in
                stage.get(use: fetchStageById)
            }
            
            //stages/:stageName/terrain
            stage.group(PathComponent(stringLiteral: StageRoute.withTerrain.rawValue)) { (stage) in
                
                //stages/:stageName/terrain/:terrainId
                stage.group(PathComponent(stringLiteral: StageRoute.terrainId.rawValue)) { (stage) in
                    stage.get(use: fetchStageByTerrainID)
                }
            }
            
        }
        
    }
    
    func fetchAllStages(req: Request) throws -> EventLoopFuture<[Stage.Inoutput]> {
        
        let stageType = try self.verifyDataRoutes(req: req)
        
        return Stage.query(on: req.db)
            .filter(\.$type == stageType)
            .all().map { stages in
                let outputs = stages.map { stage in
                    Stage.Inoutput(id: stage.id!, terrain: stage.$terrain.id, stageType: StageTypes(rawValue: stage.type.rawValue)!)
                }
                return outputs
        }
    }
    
    func fetchStageById(req: Request) throws -> EventLoopFuture<Stage.Inoutput> {
        
        let stageType = try self.verifyDataRoutes(req: req)
        
        return Stage.find(req.parameters.get(StageParameters.stageId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing {
                
                //Valida se o a etapa informada na url eh a mesma que ira ser retornada no output.
                if stageType != $0.type {
                    throw Abort(.badRequest)
                }
                
                return Stage.Inoutput(id: $0.id!, terrain: $0.$terrain.id , stageType: StageTypes(rawValue: $0.type.rawValue)!)
        }
    }
    
    func fetchStageByTerrainID(req: Request) throws -> EventLoopFuture<Stage.Inoutput> {
        
        let stageType = try self.verifyDataRoutes(req: req)
        
        guard let terrainId = req.parameters.get((StageParameters.terrainId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Stage.query(on: req.db)
            .group(.and) { group in
                group.filter(\.$type == stageType).filter("terrain_id", .equal, terrainId)
            }.first().unwrap(or: Abort(.notFound))
            .map {
                return Stage.Inoutput(id: $0.id!, terrain: $0.$terrain.id, stageType: StageTypes(rawValue: $0.type.rawValue)!)
            }

    }
    
    
    /// Method used to validate and get a stage type from data request
    /// - Parameter req: data request
    /// - Throws: possible error in validation
    /// - Returns: returns a stage type getted from url
    func verifyDataRoutes(req: Request) throws -> StageTypes{
        
        //Verifica se consegue pegar o parametro da url
        guard let reqParameter = req.parameters.get(StageParameters.stageName.rawValue, as: String.self) else {
            throw Abort(.badRequest)
        }
        
        //Verifica se o tipo informado no parametro da url eh um tipo de stage
        guard let verifyStagePath = StageTypes(rawValue: reqParameter)  else {
            throw Abort(.badRequest)
        }
        
        return verifyStagePath
    }
    
}


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
            
            //stages/:stageName/container
            stage.group(PathComponent(stringLiteral: StageRoute.withContainer.rawValue)) { (stage) in
                
                //stages/:stageName/container/:containerId
                stage.group(PathComponent(stringLiteral: StageRoute.containerId.rawValue)) { (stage) in
                    stage.get(use: fetchStageByContainerId)
                }
            }
            
        }
        
    }
    
    func fetchAllStages(req: Request) throws -> EventLoopFuture<[Stage.Inoutput]> {
        
        
        let stageType = try self.verifyDataRoutes(req: req)
        
        return Stage.query(on: req.db)
            .filter(\.$type == stageType)
            .all().flatMapThrowing { stages in
                let outputs = stages.map { stage in
                    Stage.Inoutput(id: stage.id!, container: stage.$container.id, stageType: StageTypes(rawValue: stage.type.rawValue)!)
                }
                return outputs
        }
    }
    
    func fetchStageById(req: Request) throws -> EventLoopFuture<Stage.Inoutput> {
        
                
        return Stage.find(req.parameters.get(StageParameters.stageId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing {
                return Stage.Inoutput(id: $0.id!, container: $0.$container.id , stageType: StageTypes(rawValue: $0.type.rawValue)!)
        }
    }
    
    func fetchStageByContainerId(req: Request) throws -> EventLoopFuture<Stage.Inoutput> {
        
        
        let stageType = try self.verifyDataRoutes(req: req)
        
        guard let terrainId = req.parameters.get((StageParameters.containerId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Stage.query(on: req.db)
            .group(.and) { group in
                group.filter(\.$type == stageType).filter("container_id", .equal, terrainId)
            }.first().unwrap(or: Abort(.notFound))
            .flatMapThrowing {
                return Stage.Inoutput(id: $0.id!, container: $0.$container.id, stageType: StageTypes(rawValue: $0.type.rawValue)!)
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


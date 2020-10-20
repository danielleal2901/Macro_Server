//
//  TerrainController.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Fluent
import FluentPostgresDriver
import Vapor

struct StagesContainerController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        //containers
        let containers = routes.grouped(StagesContainerRoutes.getPathComponent(.main))
        
        containers.get(use: fetchAllContainers(req:))
        
        //containers/:containerId
        containers.group(StagesContainerRoutes.getPathComponent(.id)) { (terrain) in
            terrain.get(use: fetchContainerById(req: ))
        }
    }
    
    func fetchAllContainers(req: Request) throws -> EventLoopFuture<[StagesContainer.Inoutput]>  {
        
        let containerType = try self.verifyContainerTypes(req: req)
        
        return StagesContainer.query(on: req.db)
            .filter(\.$type == containerType)
            .all().map { containers in
                let outputs = containers.map { container in
                    StagesContainer.Inoutput(type: container.type, stages: container.stages.compactMap({ stageString in
                        return StageTypes(rawValue: stageString)
                    }), id: container.id!)
                }
                return outputs
        }
    }
    
    func fetchContainerById(req: Request) throws -> EventLoopFuture<StagesContainer.Inoutput> {
        
        let containerType = try self.verifyContainerTypes(req: req)

        return StagesContainer.find(req.parameters.get(StagesContainerRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing {
                
                //Valida se o a etapa informada na url eh a mesma que ira ser retornada no output.
                if containerType != $0.type {
                    throw Abort(.badRequest)
                }
                
                return StagesContainer.Inoutput(type: $0.type, stages: $0.stages.compactMap({ (stageString) in
                    return StageTypes(rawValue: stageString)
                }) , id: $0.id!)
        }
    }
    
    /// Method used to validate and get a stage type from data request
    /// - Parameter req: data request
    /// - Throws: possible error in validation
    /// - Returns: returns a stage type getted from url
    func verifyContainerTypes(req: Request) throws -> StagesContainerTypes{
        
        //Verifica se consegue pegar o parametro da url
        guard let reqParameter = req.parameters.get(StagesContainerRoutes.containerType.rawValue, as: String.self) else {
            throw Abort(.badRequest)
        }
        
        //Verifica se o tipo informado no parametro da url eh um tipo de stage
        guard let verifyContainerType = StagesContainerTypes(rawValue: reqParameter)  else {
            throw Abort(.badRequest)
        }
        
        return verifyContainerType
    }

}


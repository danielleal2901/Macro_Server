//
//  StagesContainerController.swift
//  
//
//  Created by Daniel Leal on 20/10/20.
//

import Fluent
import FluentPostgresDriver
import Vapor

struct StagesContainerController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        //containers
        let containers = routes.grouped(StagesContainerRoutes.getPathComponent(.main))
        
        //containers/parent/parentId
        containers.group(StagesContainerRoutes.getPathComponent(.withParent)) { (container) in
            container.group(StagesContainerRoutes.getPathComponent(.parentId)) { (container) in
                container.get(use: fetchAllContainersByParentId(req: ))
            }
        }
            
        //containers/:containerType
        containers.group(StagesContainerRoutes.getPathComponent(.withType)) { (container) in
            container.group(StagesContainerRoutes.getPathComponent(.containerType)) { (container) in
                container.get(use: fetchAllWithTypeContainers(req:))
            }
        }
        
        //containers/:containerId
        containers.group(StagesContainerRoutes.getPathComponent(.id)) { (container) in
            container.get(use: fetchContainerById(req: ))
        }
    }
    
    func fetchAllContainersByParentId(req: Request) throws -> EventLoopFuture<[StagesContainer.Inoutput]>  {
        guard let parentId = req.parameters.get(StagesContainerParameters.withParent.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return StagesContainer.query(on: req.db)
            .filter("farm_id", .equal, parentId)
            .all().flatMapThrowing { containers in
                let outputs = containers.map { container in
                    StagesContainer.Inoutput(type: container.type, stages: container.stages.compactMap({ stageString in
                        return StageTypes(rawValue: stageString)
                    }), id: container.id!, farmId: container.$farm.id)
                }
                return outputs
        }
        
    }
    
    func fetchAllWithTypeContainers(req: Request) throws -> EventLoopFuture<[StagesContainer.Inoutput]>  {
        
        let containerType = try self.verifyContainerTypes(req: req)
        
        return StagesContainer.query(on: req.db)
            .filter(\.$type == containerType)
            .all().flatMapThrowing { containers in
                let outputs = containers.map { container in
                    StagesContainer.Inoutput(type: container.type, stages: container.stages.compactMap({ stageString in
                        return StageTypes(rawValue: stageString)
                    }), id: container.id!, farmId: container.$farm.id)
                }
                return outputs
        }
    }
    
    func fetchContainerById(req: Request) throws -> EventLoopFuture<StagesContainer.Inoutput> {
        
        return StagesContainer.find(req.parameters.get(StagesContainerRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing {
                return StagesContainer.Inoutput(type: $0.type, stages: $0.stages.compactMap({ (stageString) in
                    return StageTypes(rawValue: stageString)
                }) , id: $0.id!, farmId: $0.$farm.id)
        }
    }
    
    /// Method used to validate and get a container type from request
    /// - Parameter req: request
    /// - Throws: possible error in validation
    /// - Returns: returns a container type getted from url
    func verifyContainerTypes(req: Request) throws -> StagesContainerTypes{
        
        //Verifica se consegue pegar o parametro da url
        guard let reqParameter = req.parameters.get(StagesContainerParameters.containerType.rawValue, as: String.self) else {
            throw Abort(.badRequest)
        }
        
        //Verifica se o tipo informado no parametro da url eh um tipo de stage
        guard let verifyContainerType = StagesContainerTypes(rawValue: reqParameter)  else {
            throw Abort(.badRequest)
        }
        
        return verifyContainerType
    }

}


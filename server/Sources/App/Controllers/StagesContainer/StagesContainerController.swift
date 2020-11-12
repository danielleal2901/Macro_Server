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
        
        //containers/terrain/
        containers.group(StagesContainerRoutes.getPathComponent(.withTerrainType)) { (container) in
            
            //containers/terrain/parent
            container.group(StagesContainerRoutes.getPathComponent(.withParent)) { (container) in
                
                //containers/:containerType/parent/:parentId
                container.group(StagesContainerRoutes.getPathComponent(.parentId)) { (container) in
                    container.get(use: fetchTerrainContainersByParentId(req: ))
                }
                
            }
        }

        //containers/containerType
        containers.group(StagesContainerRoutes.getPathComponent(.withType)) { (container) in
            
            //containers/type/:containerType
            container.group(StagesContainerRoutes.getPathComponent(.containerType)) { (container) in
                container.get(use: fetchAllWithTypeContainers(req:))
                
                //containers/type/:containerType/parent/
                container.group(StagesContainerRoutes.getPathComponent(.withParent)) { (container) in
                    
                    //containers/:containerType/parent/:parentId
                    container.group(StagesContainerRoutes.getPathComponent(.parentId)) { (container) in
                        container.get(use: fetchContainerByTypeAndParentId(req: ))
                    }
                }
            }
        }
        
        //containers/:containerId
        containers.group(StagesContainerRoutes.getPathComponent(.id)) { (container) in
            container.get(use: fetchContainerById(req: ))
        }
    }
    
    func fetchAllContainersByParentId(req: Request) throws -> EventLoopFuture<[StagesContainer.Inoutput]>  {
        try req.auth.require(User.self)
        
        guard let parentId = req.parameters.get(StagesContainerParameters.withParent.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return StagesContainer.query(on: req.db)
            .filter("farm_id", .equal, parentId)
            .all().flatMapThrowing { containers in
                let outputs = containers.map { container in
                    StagesContainer.Inoutput(type: container.type, stages: container.stages.compactMap({ stageString in
                        return StageTypes(rawValue: stageString)
                    }), id: container.id!, farmId: container.$farm.id, name: container.name)
                }
                return outputs
        }
        
    }
    
    func fetchAllWithTypeContainers(req: Request) throws -> EventLoopFuture<[StagesContainer.Inoutput]>  {
        try req.auth.require(User.self)
        
        let containerType = try self.verifyContainerTypes(req: req)
        
        
        return StagesContainer.query(on: req.db)
            .filter(\.$type == containerType)
            .all().flatMapThrowing { containers in
                let outputs = containers.map { container in
                    StagesContainer.Inoutput(type: container.type, stages: container.stages.compactMap({ stageString in
                        return StageTypes(rawValue: stageString)
                    }), id: container.id!, farmId: container.$farm.id, name: container.name)
                }
                return outputs
        }
    }
    
    func fetchTerrainContainersByParentId(req: Request) throws -> EventLoopFuture<[StagesContainer.Inoutput]>  {
        try req.auth.require(User.self)
        
        guard let parentId = req.parameters.get(StagesContainerParameters.withParent.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return StagesContainer.query(on: req.db)
            .group(.and){ group in
            group.filter(\.$type == .terrain).filter("farm_id", .equal, parentId)}
            .all().flatMapThrowing { containers in
            let outputs = containers.map { container in
                StagesContainer.Inoutput(type: container.type, stages: container.stages.compactMap({ stageString in
                    return StageTypes(rawValue: stageString)
                }), id: container.id!, farmId: container.$farm.id, name: container.name)
            }
            return outputs
        }
    }
    
    func fetchContainerByTypeAndParentId(req: Request) throws -> EventLoopFuture<StagesContainer.Inoutput>  {
        try req.auth.require(User.self)
        
        let containerType = try self.verifyContainerTypes(req: req)
        guard let parentId = req.parameters.get(StagesContainerParameters.withParent.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return StagesContainer.query(on: req.db)
            .group(.and){ group in
            group.filter(\.$type == containerType).filter("farm_id", .equal, parentId)}
            .first().unwrap(or: Abort(.notFound))
            .flatMapThrowing {
                return StagesContainer.Inoutput(type: $0.type, stages: $0.stages.compactMap({ (stageString) in
                    return StageTypes(rawValue: stageString)
                }) , id: $0.id!, farmId: $0.$farm.id, name: $0.name)
        }
        
    }

    
    func fetchContainerById(req: Request) throws -> EventLoopFuture<StagesContainer.Inoutput> {
        try req.auth.require(User.self)
        
        return StagesContainer.find(req.parameters.get(StagesContainerRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing {
                return StagesContainer.Inoutput(type: $0.type, stages: $0.stages.compactMap({ (stageString) in
                    return StageTypes(rawValue: stageString)
                }) , id: $0.id!, farmId: $0.$farm.id, name: $0.name)
        }
    }
    
    /// Method used to validate and get a container type from request
    /// - Parameter req: request
    /// - Throws: possible error in validation
    /// - Returns: returns a container type getted from url
    func verifyContainerTypes(req: Request) throws -> StagesContainerTypes{
        try req.auth.require(User.self)
        
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


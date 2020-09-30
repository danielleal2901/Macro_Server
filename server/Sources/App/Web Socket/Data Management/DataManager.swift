//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor
import Foundation

class DataManager: DataManagerLogic{
    // Terrain
    internal func createTerrain(terrainInput: Terrain.Inoutput,req: Request) throws -> EventLoopFuture<Terrain>{
        let terrain = Terrain(name: terrainInput.name, stages: terrainInput.stages.map({$0.rawValue}))
//
        let stages = terrainInput.stages.map{
            Stage(type: $0.self, terrainID: terrain.id!)
        }
        
        return terrain.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informacoes Responsavel", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, sections: [StatusSection(name: "Tarefas Principais", items: [StatusItem(key: "Cooletar dados do shapefile", done: true)])]).create(on: req.db)
                    }
                }
            }
        }.transform(to: terrain)
    }
    internal func updateTerrain(req: Request,newTerrain: Terrain.Inoutput) throws -> EventLoopFuture<Terrain>{
        guard let uuid = UUID(uuidString: newTerrain.id!) else {throw Abort(.notFound)}
        
        return Terrain.find(uuid, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (terrain) in
                terrain.name = newTerrain.name
                terrain.stages = newTerrain.stages.map({$0.rawValue})
                return terrain.update(on: req.db).transform(to: terrain)
        }
    }
    internal func deleteTerrain(req: Request,terrain: Terrain.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        guard let uuid = UUID(uuidString: terrain.id!) else {throw Abort(.notFound)}
        
        return Terrain.find(uuid, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    // Stage
    internal func updateStage(req: Request,newStage: Stage.Inoutput) throws -> EventLoopFuture<Stage>{
        guard let uuid = UUID(uuidString: newStage.id) else {throw Abort(.notFound)}
        
        return Stage.find(uuid, on: req.db).flatMap { (stage) in
            return stage!.update(on: req.db).transform(to: stage!)
        }
    }
    internal func deleteStage(req: Request,stage: Stage.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        guard let uuid = UUID(uuidString: stage.id) else {throw Abort(.badRequest)}
        guard let terrainId = UUID(uuidString: stage.terrain) else {throw Abort(.badRequest)}
        
        
        return Terrain.find(terrainId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { terrain in
                terrain.stages.removeAll {$0 == stage.stageType.rawValue}
                return terrain.update(on: req.db)
                    .flatMap({ _ in
                        Stage.find(uuid, on: req.db)
                            .unwrap(or: Abort(.notFound))
                            .flatMap { deleteStage  in
                                return deleteStage.delete(on: req.db).transform(to: HTTPStatus.ok)
                        }
                    })
        }
 
    }
    
    
    
    // Overview
    internal func updateOverview(req: Request,newOverview: Overview.Inoutput) throws -> EventLoopFuture<Overview>{
        guard let uuid = UUID(uuidString: newOverview.id) else {throw Abort(.notFound)}
        
        return Overview.find(uuid, on: req.db).flatMap { (overview) in
            //stage?. = newStage.terrain
            return overview!.update(on: req.db).transform(to: overview!)
        }
    }
    internal func deleteOverview(req: Request,overview: Overview.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        guard let uuid = UUID(uuidString: overview.id) else {throw Abort(.notFound)}
        
        return Terrain.find(uuid, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    
    // Status
    internal func updateStatus(req: Request,newStatus: Status.Inoutput) throws -> EventLoopFuture<Status>{
        guard let uuid = UUID(uuidString: newStatus.id) else {throw Abort(.notFound)}
        
        return Status.find(uuid, on: req.db).flatMap { (status) in
            return status!.update(on: req.db).transform(to: status!)
        }
    }
    internal func deleteStatus(req: Request,status: Status.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        guard let uuid = UUID(uuidString: status.id) else {throw Abort(.notFound)}
        
        return Terrain.find(uuid, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
}

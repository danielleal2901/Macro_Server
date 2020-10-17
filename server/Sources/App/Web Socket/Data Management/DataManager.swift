//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor
import Foundation
import Fluent

class DataManager: DataManagerLogic{
    // Terrain
    internal func createTerrain(terrainInput: Terrain.Inoutput,req: Request) throws -> EventLoopFuture<HTTPStatus>{
        
        let terrain = Terrain(id: terrainInput.id, name: terrainInput.name, stages: terrainInput.stages.map({$0.rawValue}))
        
        let stages = terrainInput.stages.map{
            Stage(type: $0.self, terrainID: terrain.id!)
        }
        
        return terrain.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informacoes Responsavel", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, sections: [StatusSection(name: "Tarefas Principais", items: [StatusItem(key: "Cooletar dados do shapefile", done: true)])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db)
                                    
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    internal func updateTerrain(req: Request, newTerrain: Terrain.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return Terrain.find(newTerrain.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (terrain) in
                terrain.name = newTerrain.name
                terrain.stages = newTerrain.stages.map({$0.rawValue})
                return terrain.update(on: req.db).transform(to: .ok)
        }
    }
    internal func deleteTerrain(req: Request, terrain: Terrain.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return Terrain.find(terrain.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    // Stage
    internal func createStage(req: Request, stage: Stage.Inoutput) throws -> EventLoopFuture<HTTPStatus> {
        
        let originalStage = Stage(id: stage.id, type: stage.stageType, terrainID: stage.terrain)
        
        return Stage.query(on: req.db)
            .group(.and) { group in
                group.filter(\.$type == originalStage.type).filter("terrain_id", .equal, originalStage.$terrain.id)
        }.count().flatMapThrowing { count in
            if (count > 0) {
                throw Abort(.badRequest)
            }
        }.flatMap { _ in
            return originalStage.save(on: req.db).transform(to:.ok)
        }
        
    }
    
    internal func updateStage(req: Request,newStage: Stage.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return Stage.find(newStage.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (stage) in
                stage.type = newStage.stageType
                return stage.update(on: req.db).transform(to: .ok)
        }
    }
    internal func deleteStage(req: Request,stage: Stage.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return Stage.find(stage.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { optionalStage in
                Terrain.find(optionalStage.$terrain.id, on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { optionalTerrain in
                        optionalTerrain.stages.removeAll(where: {$0 == stage.stageType.rawValue})
                        return optionalTerrain.update(on: req.db)
                            .flatMap { _  in
                                optionalStage.delete(on: req.db).transform(to: HTTPStatus.ok)
                        }
                }
        }
        
    }
    
    // Overview
    internal func createOverview(req: Request, overviewInput: Overview.Inoutput) throws -> EventLoopFuture<HTTPStatus> {
        
        let overview = Overview(id: overviewInput.id, stageId: overviewInput.stageId, sections: overviewInput.sections)
        
        return overview.create(on: req.db).transform(to:.ok)
    }
    
    internal func updateOverview(req: Request, newOverview: Overview.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return Overview.find(newOverview.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (overview) in
                overview.sections = newOverview.sections
                return overview.update(on: req.db).transform(to: .ok)
        }
        
    }
    
    internal func deleteOverview(req: Request, overview: Overview.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return  Overview.find(overview.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
        
    }
    
    
    // Status
    internal func createStatus(req: Request, statusInoutput: Status.Inoutput) throws -> EventLoopFuture<HTTPStatus> {
        
        let status = Status(id: statusInoutput.id, stageId: statusInoutput.stageId, sections: statusInoutput.sections)
        return status.create(on: req.db).transform(to: .ok)
        
    }
    
    internal func updateStatus(req: Request,newStatus: Status.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return Status.find(newStatus.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (status) in
                status.sections = newStatus.sections
                return status.update(on: req.db).transform(to: .ok)
        }
    }
    
    internal func deleteStatus(req: Request,status: Status.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        return Status.find(status.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    // Documents
    internal func createDocument(req: Request, documentInoutput: Document.Inoutput) throws -> EventLoopFuture<HTTPStatus> {
        
        let doc = Document(id: documentInoutput.id, stageId: documentInoutput.stageId, sections: documentInoutput.sections)
        return doc.create(on: req.db).map({ doc }).transform(to: .ok)
        
    }
    
    internal func updateDocument(req: Request, newDocument: Document.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        
        return Document.find(newDocument.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (document) in
                document.sections = newDocument.sections
                return document.update(on: req.db).transform(to: .ok)
        }
        
    }
    
    internal func deleteDocument(req: Request, document: Document.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        return Document.find(document.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    //Files
    internal func deleteFile(req: Request, fileItemId: UUID) throws -> EventLoopFuture<HTTPStatus>{
        return Files.query(on: req.db)
            .filter("item_id", .equal, fileItemId)
            .first().unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    
    
}

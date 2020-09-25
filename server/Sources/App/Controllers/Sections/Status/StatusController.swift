//
//  File.swift
//  
//
//  Created by Daniel Leal on 24/09/20.
//

import Foundation
import Vapor
import Fluent

class StatusController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        
        //Status
        let statusMain = routes.grouped(StatusRoutes.getPathComponent(.main))
        
        statusMain.post(use: insertStatus)
        statusMain.get(use: fetchAllStatuss)

        //Status/StatusId
        statusMain.group(StatusRoutes.getPathComponent(.id)) { (status) in
            status.delete(use: deleteStatusById)
            status.get(use: fetchStatusById)
            status.put(use: updateStatusById)
        }
    
        //Status/stage
        statusMain.group(StatusRoutes.getPathComponent(.withStage)) { (status) in
        
            //Status/stage/stageId
            status.group(StatusRoutes.getPathComponent(.stageId)) { (status) in
                status.get(use: fetchStatusByStageId)
            }
        }
    }

    func insertStatus(req: Request) throws -> EventLoopFuture<Status.Output> {
        
        let StatusInput = try req.content.decode(Status.Input.self)
        
        guard let id = UUID(uuidString: StatusInput.stageId) else {
            throw Abort(.badRequest)
        }
        
        let status = Status(stageId: id, sections: StatusInput.sections)

        return status.create(on: req.db).transform(to:Status.Output(id: status.id!.uuidString, stageId: status.$stage.id.uuidString, sections: status.sections))
    }
    
    func fetchAllStatuss(req: Request) throws -> EventLoopFuture<[Status]> {
        return Status.query(on: req.db).all()
    }
    
    func fetchStatusById(req: Request) throws -> EventLoopFuture<Status> {
        return Status.find(req.parameters.get(StatusRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func fetchStatusByStageId (req: Request) throws -> EventLoopFuture<Status.Output> {
        
        guard let stageId = req.parameters.get((StatusParameters.stageId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Status.query(on: req.db)
            .filter("stage_id", .equal, stageId)
            .first().unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalStatus in
                Status.Output(id: try optionalStatus.requireID().uuidString, stageId: optionalStatus.$stage.id.uuidString, sections: optionalStatus.sections)
            }
        
    }
    
    func deleteStatusById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(StatusParameters.statusId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Status.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func updateStatusById(req: Request) throws -> EventLoopFuture<Status.Output> {
        guard let id = req.parameters.get(StatusParameters.statusId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let newStatus = try req.content.decode(Status.Input.self)
        return Status.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { oldStatus in
                oldStatus.sections = newStatus.sections
                let _ = oldStatus.save(on: req.db)
                
                return Status.Output(id: oldStatus.id!.uuidString, stageId: oldStatus.$stage.id.uuidString, sections: oldStatus.sections)
            }
        
    }






}

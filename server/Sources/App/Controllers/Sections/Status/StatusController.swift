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
        
        statusMain.get(use: fetchAllStatuss)

        //Status/StatusId
        statusMain.group(StatusRoutes.getPathComponent(.id)) { (status) in
            status.get(use: fetchStatusById)
        }
    
        //Status/stage
        statusMain.group(StatusRoutes.getPathComponent(.withStage)) { (status) in
        
            //Status/stage/stageId
            status.group(StatusRoutes.getPathComponent(.stageId)) { (status) in
                status.get(use: fetchStatusByStageId)
            }
        }
    }

    func fetchAllStatuss(req: Request) throws -> EventLoopFuture<[Status.Inoutput]> {
        
        
        return Status.query(on: req.db).all().map { allStatus in
            allStatus.map { status in
                return Status.Inoutput(id: status.id!, stageId: status.$stage.id, tasks: status.tasks)
            }
        }
    }
    
    func fetchStatusById(req: Request) throws -> EventLoopFuture<Status.Inoutput> {
        
        
        return Status.find(req.parameters.get(StatusRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing { optionalStatus in
                return Status.Inoutput(id: optionalStatus.id!, stageId: optionalStatus.$stage.id, tasks: optionalStatus.tasks)
        }
    }
    
    func fetchStatusByStageId (req: Request) throws -> EventLoopFuture<Status.Inoutput> {
        
        
        guard let stageId = req.parameters.get((StatusParameters.stageId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Status.query(on: req.db)
            .filter("stage_id", .equal, stageId)
            .first().unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalStatus in
                Status.Inoutput(id: try optionalStatus.requireID(), stageId: optionalStatus.$stage.id, tasks: optionalStatus.tasks)
            }
        
    }

}

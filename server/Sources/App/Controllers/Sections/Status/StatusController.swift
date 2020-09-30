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

    func fetchAllStatuss(req: Request) throws -> EventLoopFuture<[Status]> {
        return Status.query(on: req.db).all()
    }
    
    func fetchStatusById(req: Request) throws -> EventLoopFuture<Status> {
        return Status.find(req.parameters.get(StatusRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func fetchStatusByStageId (req: Request) throws -> EventLoopFuture<Status.Inoutput> {
        
        guard let stageId = req.parameters.get((StatusParameters.stageId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Status.query(on: req.db)
            .filter("stage_id", .equal, stageId)
            .first().unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalStatus in
                Status.Inoutput(id: try optionalStatus.requireID().uuidString, stageId: optionalStatus.$stage.id.uuidString, sections: optionalStatus.sections)
            }
        
    }

}

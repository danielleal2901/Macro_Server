//
//  File.swift
//
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

class OverviewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        //overviews
        let overviewMain = routes.grouped(OverviewRoutes.getPathComponent(.main))
        
        overviewMain.post(use: insertOverview)
        overviewMain.get(use: fetchAllOverviews)
//
        //overviews/overviewId
        overviewMain.group(OverviewRoutes.getPathComponent(.id)) { (overview) in
//            overview.delete(use: deleteOverviewById)
            overview.get(use: fetchOverviewById)
//            overview.put(use: updateOverviewById)
        }
    
        //overviews/stage
        overviewMain.group(OverviewRoutes.getPathComponent(.withStage)) { (overview) in
        
            //overviews/stage/stageId
            overview.group(OverviewRoutes.getPathComponent(.stageId)) { (overview) in
                overview.get(use: fetchOverviewByStageId)
            }
        }
    }

    func insertOverview(req: Request) throws -> EventLoopFuture<Overview.Output> {
        
        let overviewInput = try req.content.decode(Overview.Input.self)
        
        guard let id = UUID(uuidString: overviewInput.stageId) else {
            throw Abort(.badRequest)
        }
        
        let overview = Overview(stageID: id, sections: overviewInput.sections)

        return overview.create(on: req.db).transform(to:Overview.Output(id: overview.id!.uuidString, stageId: overview.$stage.id.uuidString, sections: overview.sections))
    }
    
    func fetchAllOverviews(req: Request) throws -> EventLoopFuture<[Overview]> {
        return Overview.query(on: req.db).all()
    }
    
    func fetchOverviewById(req: Request) throws -> EventLoopFuture<Overview> {
        return Overview.find(req.parameters.get(OverviewRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func fetchOverviewByStageId (req: Request) throws -> EventLoopFuture<Overview.Output> {
        
        guard let stageId = req.parameters.get((OverviewParameters.stageId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Overview.query(on: req.db)
            .filter("stage_id", .equal, stageId)
            .first().unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalOverview in
                Overview.Output(id: try optionalOverview.requireID().uuidString, stageId: optionalOverview.$stage.id.uuidString, sections: optionalOverview.sections)
            }
        
    }
    
}


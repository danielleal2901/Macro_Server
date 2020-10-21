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
        
        overviewMain.get(use: fetchAllOverviews)

        //overviews/overviewId
        overviewMain.group(OverviewRoutes.getPathComponent(.id)) { (overview) in
            overview.get(use: fetchOverviewById)
        }
    
        //overviews/stage
        overviewMain.group(OverviewRoutes.getPathComponent(.withStage)) { (overview) in
        
            //overviews/stage/stageId
            overview.group(OverviewRoutes.getPathComponent(.stageId)) { (overview) in
                overview.get(use: fetchOverviewByStageId)
            }
        }
    }
    
    func fetchAllOverviews(req: Request) throws -> EventLoopFuture<[Overview.Inoutput]> {
        return Overview.query(on: req.db).all().map { allOverviews in
            return allOverviews.map { overview in
                Overview.Inoutput(id: overview.id!, stageId: overview.stage.id!, sections: overview.sections)
            }
        }
    }
    
    func fetchOverviewById(req: Request) throws -> EventLoopFuture<Overview.Inoutput> {
        return Overview.find(req.parameters.get(OverviewRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing { optionalOverview in
                return Overview.Inoutput(id: optionalOverview.id!, stageId: optionalOverview.$stage.id, sections: optionalOverview.sections)
        }
    }
    
    func fetchOverviewByStageId (req: Request) throws -> EventLoopFuture<Overview.Inoutput> {
        
        guard let stageId = req.parameters.get((OverviewParameters.stageId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Overview.query(on: req.db)
            .filter("stage_id", .equal, stageId)
            .first().unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalOverview in
                Overview.Inoutput(id: try optionalOverview.requireID(), stageId: optionalOverview.$stage.id, sections: optionalOverview.sections)
            }
        
    }

}


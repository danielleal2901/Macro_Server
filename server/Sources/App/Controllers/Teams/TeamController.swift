//
//  File.swift
//  
//
//  Created by Antonio Carlos on 16/10/20.
//

import Foundation
import Vapor
import Fluent

class TeamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let teamMain = routes.grouped(TeamRoutes.getPathComponent(.main))
        
        teamMain.on(.POST, body: .collect(maxSize: "1mb")) { req in
             try self.insertTeam(req: req)
        }
    }
    
    func insertTeam(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let teamReq = try req.content.decode(TeamRequest.self)
        
        let team = Team(id: nil, name: teamReq.name, description: teamReq.description, image: teamReq.image)
           
        return team.create(on: req.db)
            .map({ team })
            .transform(to: .ok)
    }
}

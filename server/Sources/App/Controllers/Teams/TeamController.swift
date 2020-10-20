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
        
        teamMain.group(TeamRoutes.getPathComponent(.id)) { (teams) in
            teams.get(use: getTeamById(req:))
            teams.on(.PUT, body: .collect(maxSize: "1mb")) { (req) in
                try self.updateTeamById(req: req)
            }
        }
        
    }
    
    func insertTeam(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let teamReq = try req.content.decode(TeamRequest.self)
        
        let team = Team(id: nil, name: teamReq.name, description: teamReq.description, image: teamReq.image)
           
        return team.create(on: req.db)
            .map({ team })
            .transform(to: .ok)
    }
    
    func getTeamById(req: Request) throws -> EventLoopFuture<TeamResponse> {
        guard let teamID = req.parameters.get(TeamParameters.teamId.rawValue, as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        return Team.find(teamID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { (optionalTeam) in
                return TeamResponse(id: optionalTeam.id, name: optionalTeam.name, description: optionalTeam.description, image: optionalTeam.image)
            }
    }
    
    func updateTeamById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let teamID = req.parameters.get(TeamParameters.teamId.rawValue, as: UUID.self) else {
            throw Abort(.notFound)
        }
        let newTeam = try req.content.decode(TeamRequest.self)
        
        return Team.find(teamID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (team) in
                team.name = newTeam.name
                team.description = newTeam.description
                team.image = newTeam.image
                return team.update(on: req.db).transform(to: .ok)
            }
    }
    
    
}

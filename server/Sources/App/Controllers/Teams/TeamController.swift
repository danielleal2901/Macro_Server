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
        
        teamMain.on(.POST, body: .collect(maxSize: "20mb")) { req in
            try self.insertTeam(req: req)
        }
        
        teamMain.group(TeamRoutes.getPathComponent(.id)) { (teams) in
            teams.get(use: getTeamById(req:))
        }
        
    }
    
    func insertTeam(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        
        let teamReq = try req.content.decode(TeamRequest.self)
        let team = Team(id: teamReq.id, name: teamReq.name, description: teamReq.description, image: teamReq.image, employeeToken: teamReq.employeeToken, guestToken: teamReq.guestToken, activeUsers: teamReq.activeUsers)
        return team.create(on: req.db)
            .map({ team })
            .transform(to: .ok)
    }
    
    func getTeamById(req: Request) throws -> EventLoopFuture<TeamResponse> {
        
        
        guard let teamID = req.parameters.get(TeamParameters.teamId.rawValue, as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        return User.query(on: req.db).filter("team_id", .equal, teamID).all().flatMap { (users) in
            Team.find(teamID, on: req.db)
                .unwrap(or: Abort(.notFound))
                .map { (optionalTeam) -> TeamResponse in
                    
                    let activeUsers = optionalTeam.activeUsers.map { (id) -> UserResponse? in
                        if let user = users.first(where: { (user) -> Bool in
                            return user.id == id
                        }) {
                            return UserResponse(id: user.id!,
                                                name: user.name,
                                                email: user.email,
                                                password: user.password,
                                                isAdmin: user.isAdmin,
                                                image: user.image,
                                                teamId: user.$team.id)
                        }
                        return nil
                    }.compactMap{$0}
                    
                    let allUsers = users.map { (user) -> UserResponse in
                        return UserResponse(id: user.id!,
                                            name: user.name,
                                            email: user.email,
                                            password: user.password,
                                            isAdmin: user.isAdmin,
                                            image: user.image,
                                            teamId: user.$team.id)
                    }
                    
                    return TeamResponse(id: optionalTeam.id!,
                                        name: optionalTeam.name,
                                        description: optionalTeam.description,
                                        image: optionalTeam.image,
                                        employeeToken: optionalTeam.employeeToken,
                                        guestToken: optionalTeam.guestToken,
                                        activeUsers: activeUsers, allUsers: allUsers)
                }
        }
    }
    
    
}

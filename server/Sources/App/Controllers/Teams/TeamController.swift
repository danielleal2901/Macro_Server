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
        
        return Team.find(teamID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (optionalTeam) in
                
                var teamResponse = TeamResponse(id: optionalTeam.id, name: optionalTeam.name, description: optionalTeam.description, image: optionalTeam.image, employeeToken: optionalTeam.employeeToken, guestToken: optionalTeam.guestToken, activeUsers: [])
                
                let promise = req.eventLoop.makePromise(of: Bool.self)
                
                
                let _ = optionalTeam.activeUsers.map { (id) in
                    User.find(id, on: req.db)
                        .unwrap(or: Abort(.notFound))
                        .map { (optionalUser) -> Void in
                            let user = UserResponse(id: optionalUser.id!,
                                            name: optionalUser.name,
                                            email: optionalUser.email,
                                            password: optionalUser.password,
                                            isAdmin: optionalUser.isAdmin,
                                            image: optionalUser.image,
                                            teamId: optionalUser.$team.id)

                            teamResponse.activeUsers.append(user)
                            if(optionalUser.id == teamResponse.activeUsers.last!.id) {
                                promise.succeed(true)
                            }
                            return
                        }
                }
                
                return promise.futureResult.flatMapThrowing { (success) in
                    if !success {
                        throw Abort(.badRequest)
                    } else {
                        return teamResponse
                    }
                }
                
//                .map { (response) in
//                    response.transform(to: teamResponse)
//                }.f
                
//                .map { (_) in
//                    return teamResponse
//                }
                
                
                
//                .map { (users) in
//                    return users.mapEach { (user) -> User in
//                        teamResponse.activeUsers.append(user)
//                        return user
//                    }.transform(to: teamResponse)
//                }.flatMap { (teamResponse) in
//                    return teamResponse
//                }
                
//                return getActiveUsers.map { (usersEvent) in
//                    usersEvent.mapEach { (user) in
//                        return user
//                    }
//                }
                
//                return users.map { (user) in
//                    teamResponse.activeUsers.append(user)
//                }
                
//                return appendUsers.map { (_) in
//                    return teamResponse
//                }
                
                
                
//                return optionalTeam.activeUsers.map { (id) in
//                    return User.query(on: req.db)
//
//                        .mapEach { (user) in
//                            return user
//                        }
//                        .map { (users) -> TeamResponse in
//                            let users = [User]()
//                            users.mapEach { (user) in
//                                users.append(user)
//                            }
//                            return users
//                        }
//                }
            }
    }
    
    
}

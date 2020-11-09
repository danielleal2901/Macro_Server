//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 09/11/20.
//

import Foundation
import Vapor

class MarkerController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let markerMain = routes.grouped(MarkerRoutes.getPathComponent(.main))
        markerMain.post(use: insertMarker)
        
        
        markerMain.group(MarkerRoutes.getPathComponent(.id)) { marker in
            marker.get(use: fetchAllMarkersByTeamId)
            marker.put(use: updateMarkerById)
            marker.delete(use: deleteMarkerById)
        }
    }
        
    func insertMarker(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        let farm = try req.content.decode(Farm.self)
        
        return farm.create(on: req.db).flatMapThrowing {
            try self.setupTerritorialDiagnosisContainer(req: req, farmId: farm.id!).flatMapThrowing({ http in
                try self.setupSocialMobContainer(req: req, farmId: farm.id!).flatMapThrowing({ (http) in
                    try self.setupEnvironmentalContainer(req: req, farmId: farm.id!).flatMapThrowing({ (http) in
                        try self.setupDescMemorialContainer(req: req, farmId: farm.id!).transform(to: ())
                    })
                })
            })
            
        }.transform(to: .ok)

    }
    
    func updateMarkerById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let newFarm = try req.content.decode(Farm.self)
        
        guard let id = req.parameters.get(FarmParameters.idFarm.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
        
        return Farm.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (farm) in
                farm.name = newFarm.name
                farm.desc = newFarm.desc
                farm.teamId = newFarm.teamId
                return farm.update(on: req.db).transform(to: .ok)
        }
    }
        
    func fetchAllMarkersByTeamId(req: Request) throws -> EventLoopFuture<[Marker]> {
        
        guard let id = req.parameters.get(FarmParameters.teamId.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
        
        return Farm.query(on: req.db)
            .filter("teamId", .equal, id)
            .all().map { allFarms in
            allFarms.map { farm in
                Farm.Inoutput(id: farm.id!, name: farm.name, teamId: farm.teamId, icon: Data(), desc: farm.desc)
            }
        }
    }
    
    func deleteMarkerById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        guard let id = req.parameters.get(FarmParameters.idFarm.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
            
        return Farm.find(id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
            
    }
}


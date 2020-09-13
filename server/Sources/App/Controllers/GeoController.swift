//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Foundation
import Vapor

class GeoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let geo = routes.grouped(GeoRoutes.getPathComponent(.main))
        geo.post(use: insertGeoreferecing)
        geo.get(use: fetchAllGeo)
        geo.group(GeoRoutes.getPathComponent(.id)) { (geo) in
            geo.delete(use: deleteGeoById)
            geo.get(use: fetchGeoById)
            geo.put(use: updateGeoById)
        }
    }
    
    func insertGeoreferecing(req: Request) throws -> EventLoopFuture<Georeferecing> {
        let geoPost = try req.content.decode(GeoreferecingPost.self)
        let geo = Georeferecing(name: geoPost.name, terrainID: geoPost.terrainId)
        return geo.create(on: req.db).map({ geo })
    }
    
    func fetchAllGeo(req: Request) throws -> EventLoopFuture<[Georeferecing]> {
        return Georeferecing.query(on: req.db).all()
    }
    
    func fetchGeoById(req: Request) throws -> EventLoopFuture<Georeferecing> {
        return Georeferecing.find(req.parameters.get(GeoRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteGeoById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(GeoRoutes.id.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Georeferecing.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func updateGeoById(req: Request) throws -> EventLoopFuture<Georeferecing> {
        guard let id = req.parameters.get(GeoRoutes.id.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let newGeoreferecing = try req.content.decode(Georeferecing.self)
        return Georeferecing.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (oldGeoreferecing) -> EventLoopFuture<Georeferecing> in
                oldGeoreferecing.name = newGeoreferecing.name
                return oldGeoreferecing.save(on: req.db).map({ oldGeoreferecing })
        }
    }
}

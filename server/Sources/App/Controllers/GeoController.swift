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
        //With geoID
        geo.group(GeoRoutes.getPathComponent(.id)) { (geo) in
            geo.delete(use: deleteGeoById)
            geo.get(use: fetchGeoById)
            geo.put(use: updateGeoById)
        }
        //With terrainID
        geo.group(GeoRoutes.getPathComponent(.withTerrain)) { (geo) in
            geo.group(GeoRoutes.getPathComponent(.terrainId)) { (geo) in
                geo.get(use: fetchGeoByTerrainID)
            }
        }
    }
    
    func insertGeoreferecing(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
        let input = try req.content.decode(Georeferecing.Input.self)
        guard let id = UUID(uuidString: input.terrain) else {
            throw Abort(.badRequest)
        }
        let geo = Georeferecing(name: input.name, terrainID: id)
        return geo.save(on: req.db)
            .map {Georeferecing.Output(id: geo.id!.uuidString, name: geo.name, terrain: geo.$terrain.id.uuidString)}
    }
    
    func fetchAllGeo(req: Request) throws -> EventLoopFuture<[Georeferecing.Output]> {
        return Georeferecing.query(on: req.db).all().map { geos in
            let outputs = geos.map { geo in
                Georeferecing.Output(id: geo.id!.uuidString, name: geo.name, terrain: geo.$terrain.id.uuidString)
            }
            return outputs
        }
    }
    
    func fetchGeoById(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
        return Georeferecing.find(req.parameters.get(GeoParameters.geoId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).map {Georeferecing.Output(id: $0.id!.uuidString, name: $0.name, terrain: $0.$terrain.id.uuidString)}
    }
    
    func fetchGeoByTerrainID(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
        
        guard let terrainId = req.parameters.get(GeoParameters.terrainId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Georeferecing.query(on: req.db)
            .filter("terrain_id", .equal, terrainId).first().unwrap(or: Abort(.badRequest))
            .map { Georeferecing.Output(id: $0.id!.uuidString, name: $0.name, terrain: $0.$terrain.id.uuidString) }
    }
    
    
    func deleteGeoById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(GeoParameters.geoId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Georeferecing.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func updateGeoById(req: Request) throws -> EventLoopFuture<Georeferecing> {
        guard let id = req.parameters.get(GeoParameters.geoId.rawValue, as: UUID.self) else {
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

//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Foundation
import Vapor
import Fluent

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
    
//    func insertGeoreferecing(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
//        let input = try req.content.decode(Georeferecing.Input.self)
//        guard let id = UUID(uuidString: input.terrain) else {
//            throw Abort(.badRequest)
//        }
//        let geo = Georeferecing(name: input.name, terrainID: id)
//        return geo.save(on: req.db)
//            .map {Georeferecing.Output(id: geo.id!.uuidString, name: geo.name, terrain: geo.$terrain.id.uuidString)}
//    }
    
    func insertGeoreferecing(req: Request) throws -> EventLoopFuture<Stage.Output> {
        
        let input = try req.content.decode(Stage.Input.self)
        guard let id = UUID(uuidString: input.terrain) else {
            throw Abort(.badRequest)
        }
    
        guard let stageType = StageTypes(rawValue: input.stageType) else {
            throw Abort(.badRequest)
        }
        
        let stage = Stage(type: stageType, terrainID: id)

        return stage.save(on: req.db)
            .map {Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)}
    }
    
//    func fetchAllGeo(req: Request) throws -> EventLoopFuture<[Georeferecing.Output]> {
//        return Georeferecing.query(on: req.db).all().map { geos in
//            let outputs = geos.map { geo in
//                Georeferecing.Output(id: geo.id!.uuidString, name: geo.name, terrain: geo.$terrain.id.uuidString)
//            }
//            return outputs
//        }
//    }
    
    func fetchAllGeo(req: Request) throws -> EventLoopFuture<[Stage.Output]> {
        
        return Stage.query(on: req.db)
//            .filter("type", .equal, StageTypes(rawValue: "georeferecing"))
            .filter(\.$type == .georeferecing)
            .all().map { stages in
                let outputs = stages.map { stage in
                    Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)
                }
            return outputs
        }
    }
    
//    func fetchGeoById(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
//        return Georeferecing.find(req.parameters.get(GeoParameters.geoId.rawValue), on: req.db)
//            .unwrap(or: Abort(.notFound)).map {Georeferecing.Output(id: $0.id!.uuidString, name: $0.name, terrain: $0.$terrain.id.uuidString)}
//    }
    
    func fetchGeoById(req: Request) throws -> EventLoopFuture<Stage.Output> {
        return Stage.find(req.parameters.get(GeoParameters.geoId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).map {Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString , stageType: $0.type.rawValue)}
    }
    
//    func fetchGeoByTerrainID(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
//
//        guard let terrainId = req.parameters.get(GeoParameters.terrainId.rawValue, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        return Georeferecing.query(on: req.db)
//            .filter("terrain_id", .equal, terrainId).first().unwrap(or: Abort(.badRequest))
//            .map { Georeferecing.Output(id: $0.id!.uuidString, name: $0.name, terrain: $0.$terrain.id.uuidString) }
//    }
    
    func fetchGeoByTerrainID(req: Request) throws -> EventLoopFuture<Stage.Output> {
        
        guard let terrainId = req.parameters.get(GeoParameters.terrainId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Stage.query(on: req.db)
            .filter("terrain_id", .equal, terrainId).first().unwrap(or: Abort(.badRequest))
            .map { Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString, stageType: $0.type.rawValue)}
    }

    
//    func deleteGeoById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        guard let id = req.parameters.get(GeoParameters.geoId.rawValue, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        return Georeferecing.find(id, on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap({$0.delete(on: req.db)})
//            .transform(to: .ok)
//    }
    
    func deleteGeoById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(GeoParameters.geoId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Stage.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
//    func updateGeoById(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
//        guard let id = req.parameters.get(GeoParameters.geoId.rawValue, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        let input = try req.content.decode(Georeferecing.Input.self)
//        return Georeferecing.find(id, on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { geo in
//                geo.name = input.name
//                return geo.save(on: req.db)
//                    .map { Georeferecing.Output(id: geo.id!.uuidString, name: geo.name, terrain: geo.$terrain.id.uuidString)}
//        }
//    }
    
    func updateGeoById(req: Request) throws -> EventLoopFuture<Stage.Output> {
        guard let id = req.parameters.get(GeoParameters.geoId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let input = try req.content.decode(Stage.Input.self)
        return Stage.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { stage in
                //Colocar aqui o que quiser mudar
                return stage.save(on: req.db)
                    .map { Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)}
        }
    }
    
}

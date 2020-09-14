//
//  TerrainController.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Fluent
import Vapor

struct TerrainController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let terrains = routes.grouped(TerrainRoutes.getPathComponent(.main))
        terrains.post(use: insertTerrain)
        terrains.get(use: fetchAllTerrains)
        terrains.group(TerrainRoutes.getPathComponent(.id)) { (terrain) in
            terrain.delete(use: deleteTerrainById)
            terrain.get(use: fetchTerrainById)
            terrain.put(use: updateTerrainById)
        }
    }
    
    func insertTerrain(req: Request) throws -> EventLoopFuture<Terrain> {
        let terrain = try req.content.decode(Terrain.self)
        return terrain.create(on: req.db).map({ terrain })
    }
    
    func fetchAllTerrains(req: Request) throws -> EventLoopFuture<[Terrain]>  {
        return Terrain.query(on: req.db).all()
    }
    
    func fetchTerrainById(req: Request) throws -> EventLoopFuture<Terrain> {
        return Terrain.find(req.parameters.get(TerrainParameters.idTerrain.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteTerrainById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(TerrainParameters.idTerrain.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Terrain.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func updateTerrainById(req: Request) throws -> EventLoopFuture<Terrain> {
        guard let id = req.parameters.get(TerrainParameters.idTerrain.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let newTerrain = try req.content.decode(Terrain.self)
        return Terrain.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (oldTerrain) -> EventLoopFuture<Terrain> in
                oldTerrain.name = newTerrain.name
                return oldTerrain.save(on: req.db).map({ oldTerrain })
        }
    }
    
    
    
}


//
//  TerrainController.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Fluent
import FluentPostgresDriver
import Vapor


struct TerrainController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        //terrain
        let terrains = routes.grouped(TerrainRoutes.getPathComponent(.main))
        
        terrains.get(use: fetchAllTerrains)
        
        //terrain/:terrainId
        terrains.group(TerrainRoutes.getPathComponent(.id)) { (terrain) in
            terrain.get(use: fetchTerrainById)
        }
    }
    
    func fetchAllTerrains(req: Request) throws -> EventLoopFuture<[Terrain]>  {
        return Terrain.query(on: req.db).all()
    }
    
    func fetchTerrainById(req: Request) throws -> EventLoopFuture<Terrain> {
        return Terrain.find(req.parameters.get(TerrainParameters.idTerrain.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

}


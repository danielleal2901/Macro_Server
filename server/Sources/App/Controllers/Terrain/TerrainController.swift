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
        
        terrains.post(use: insertTerrain)
        terrains.get(use: fetchAllTerrains)
        
        //terrain/:terrainId
        terrains.group(TerrainRoutes.getPathComponent(.id)) { (terrain) in
            terrain.delete(use: deleteTerrainById)
            terrain.get(use: fetchTerrainById)
            terrain.put(use: updateTerrainById)
        }
    }
    
    func insertTerrain(req: Request) throws -> EventLoopFuture<Terrain> {
        let terrainInput = try req.content.decode(Terrain.Input.self)
    
        let terrain = Terrain(name: terrainInput.name, stages: terrainInput.stages.map{$0.rawValue})
        
        let stages = terrainInput.stages.map{
            Stage(type: $0.self, terrainID: terrain.id!)
        }
                                
    
        return terrain.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informacoes Responsavel", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, sections: [StatusSection(name: "Tarefas Principais", items: [StatusItem(key: "Cooletar dados do shapefile", done: true)])]).create(on: req.db)
                    }
                }
            }
        }.transform(to: terrain)
    
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
        
        let newTerrain = try req.content.decode(Terrain.Input.self)
        return Terrain.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { oldTerrain in
                oldTerrain.name = newTerrain.name
                oldTerrain.stages = newTerrain.stages.map{$0.rawValue}
                
                let _ = oldTerrain.save(on: req.db).map { (_) -> (Terrain) in
                    Terrain(name: oldTerrain.name, stages: oldTerrain.stages)
                }
                
                return oldTerrain
        }
    }
    
    
    
    //MARK: Sql Methods
    func insertTerrainSQL(terrain: TerrainModel,req: Request){
        if let sql = req.db as? PostgresDatabase{
            sql.simpleQuery("INSERT INTO terrains (id,name) VALUES ('\(terrain.id)','\(terrain.name)')").whenSuccess({ _ in
                print("Worked")
            })
        }
    }
    
    func updateTerrainSQL(terrain: TerrainModel,req: Request){
        if let sql = req.db as? PostgresDatabase{
            // Check which data changed?
            sql.simpleQuery("UPDATE terrains SET name = '\(terrain.name)' WHERE name = 'guidelas'").whenSuccess({ _ in
                print("Worked")
            })
        }
    }
    
    func deleteTerrainSQL(id: UUID, req: Request){
        if let sql = req.db as? PostgresDatabase{
            // Check which data changed?
            sql.simpleQuery("DELETE FROM terrains WHERE id = '\(id)'").whenSuccess({ _ in
                print("Worked")
            })
        }
    }
    
    
    // Use on future, for custom sql requests
    func fetchSome(req: Request){
        if let sql = req.db as? PostgresDatabase{
            sql.simpleQuery("select * from terrains").whenSuccess({ _ in
                print("Worked")
            })
        }
    }
    
    
        
}


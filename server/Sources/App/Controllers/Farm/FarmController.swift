//
//  File.swift
//
//
//  Created by Daniel Leal on 20/10/20.
//

import Foundation
import Vapor
import Fluent

class FarmController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let farmMain = routes.grouped(FarmRoutes.getPathComponent(.main))
        farmMain.post(use: insertFarm)
        farmMain.get(use: fetchAllFarms)
        
        farmMain.group(FarmRoutes.getPathComponent(.id)) { farm in
            farmMain.get(use: fetchFarmById)
            farmMain.put(use: updateFarmById)
            farmMain.delete(use: deleteFarmById)
        }
    }
    
    
    func insertFarm(req: Request) throws -> EventLoopFuture<Farm> {
        let farm = try req.content.decode(Farm.self)
        return farm.create(on: req.db).map({ farm })
    }
    
    func updateFarmById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let newFarm = try req.content.decode(Farm.self)
        return Farm.find(req.parameters.get(UserParameters.idUser.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (farm) in
                farm.name = newFarm.name
                farm.desc = newFarm.desc
                farm.teamId = newFarm.teamId
                return farm.update(on: req.db).transform(to: .ok)
        }
    }
    
    
    func fetchFarmById(req: Request) throws -> EventLoopFuture<Farm.Inoutput> {
        return Farm.find(req.parameters.get(FarmParameters.idFarm.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalFarm in
                return Farm.Inoutput(id: optionalFarm.id!, teamId: optionalFarm.teamId, name: optionalFarm.name, desc: optionalFarm.desc)
        }
    }
    
    func fetchAllFarms(req: Request) throws -> EventLoopFuture<[Farm.Inoutput]> {
        return Farm.query(on: req.db).all().map { allFarms in
            allFarms.map { farm in
                Farm.Inoutput(id: farm.id!, teamId: farm.teamId, name: farm.name, desc: farm.desc)
            }
        }
    }
    
    func deleteFarmById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        return Farm.find(req.parameters.get(FarmParameters.idFarm.rawValue), on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    
    
    
}


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
    
    
    func insertFarm(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let farm = try req.content.decode(Farm.self)
        return farm.create(on: req.db).map({ farm }).transform(to: .ok)
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
                return Farm.Inoutput(id: optionalFarm.id!, name: optionalFarm.name, teamId: optionalFarm.teamId, icon: Data(), desc: optionalFarm.desc)
        }
    }
    
    func fetchAllFarms(req: Request) throws -> EventLoopFuture<[Farm.Inoutput]> {
        return Farm.query(on: req.db).all().map { allFarms in
            allFarms.map { farm in
                Farm.Inoutput(id: farm.id!, name: farm.name, teamId: farm.teamId, icon: Data(), desc: farm.desc)
            }
        }
    }
    
    func deleteFarmById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        return Farm.find(req.parameters.get(FarmParameters.idFarm.rawValue), on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
    }
    
    
    
    
}


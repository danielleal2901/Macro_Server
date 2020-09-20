////
////  File.swift
////
////
////  Created by Daniel Leal on 20/09/20.
////
//
//import Foundation
//import Vapor
//
//class OverviewController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//
//        let overview = routes.grouped(OverviewRoutes.getPathComponent(.main))
//        overview.post(use: insertOverview)
//        overview.get(use: fetchAllOverviews)
//
//        //With overviewId
//        overview.group(OverviewRoutes.getPathComponent(.id)) { (overview) in
//            overview.delete(use: deleteOverviewById)
//            overview.get(use: fetchOverviewById)
//            overview.put(use: updateOverviewById)
//        }
//
//        //With stageId
//        overview.group(OverviewRoutes.getPathComponent(.withStage)) { (overview) in
//            overview.group(OverviewRoutes.getPathComponent(.stageId)) { (overview) in
//                overview.get(use: fetchOverviewByStageID)
//            }
//        }
//    }
//
//    func insertOverview(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
//        let input = try req.content.decode(Georeferecing.Input.self)
//        guard let id = UUID(uuidString: input.terrain) else {
//            throw Abort(.badRequest)
//        }
//        let geo = Georeferecing(name: input.name, terrainID: id)
//        return geo.save(on: req.db)
//            .map {Georeferecing.Output(id: geo.id!.uuidString, name: geo.name, terrain: geo.$terrain.id.uuidString)}
//    }
//
//    func fetchAllOverviews(req: Request) throws -> EventLoopFuture<[Georeferecing.Output]> {
//        return Georeferecing.query(on: req.db).all().map { geos in
//            let outputs = geos.map { geo in
//                Georeferecing.Output(id: geo.id!.uuidString, name: geo.name, terrain: geo.$terrain.id.uuidString)
//            }
//            return outputs
//        }
//    }
//
//    func fetchOverviewById(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
//        return Georeferecing.find(req.parameters.get(GeoParameters.geoId.rawValue), on: req.db)
//            .unwrap(or: Abort(.notFound)).map {Georeferecing.Output(id: $0.id!.uuidString, name: $0.name, terrain: $0.$terrain.id.uuidString)}
//    }
//
//    func fetchOverviewByStageID(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
//
//        guard let terrainId = req.parameters.get(GeoParameters.terrainId.rawValue, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        return Georeferecing.query(on: req.db)
//            .filter("terrain_id", .equal, terrainId).first().unwrap(or: Abort(.badRequest))
//            .map { Georeferecing.Output(id: $0.id!.uuidString, name: $0.name, terrain: $0.$terrain.id.uuidString) }
//    }
//
//
//    func deleteOverviewById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        guard let id = req.parameters.get(GeoParameters.geoId.rawValue, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        return Georeferecing.find(id, on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap({$0.delete(on: req.db)})
//            .transform(to: .ok)
//    }
//
//    func updateOverviewById(req: Request) throws -> EventLoopFuture<Georeferecing.Output> {
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
//}
//

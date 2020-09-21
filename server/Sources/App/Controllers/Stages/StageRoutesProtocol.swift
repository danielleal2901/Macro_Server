////
////  File.swift
////
////
////  Created by Daniel Leal on 20/09/20.
////
//
//import Foundation
//import Vapor
//import Fluent
//
//
//protocol StageRoutesProtocol {
//
//    
//    func insertStage(req: Request) throws -> EventLoopFuture<Stage.Output>
//    func fetchAllStages(req: Request) throws -> EventLoopFuture<[Stage.Output]>
//    func fetchStageById(req: Request) throws -> EventLoopFuture<Stage.Output>
//    func fetchStageByTerrainID(req: Request) throws -> EventLoopFuture<Stage.Output>
//    func deleteStageById(req: Request) throws -> EventLoopFuture<HTTPStatus>
//    func updateStageById(req: Request) throws -> EventLoopFuture<Stage.Output>
//    
//
//}
//
//extension StageRoutesProtocol {
//    func insertStage(req: Request) throws -> EventLoopFuture<Stage.Output> {
//
//        let input = try req.content.decode(Stage.Input.self)
//        guard let id = UUID(uuidString: input.terrain) else {
//            throw Abort(.badRequest)
//        }
//
//        guard let stageType = StageTypes(rawValue: input.stageType) else {
//            throw Abort(.badRequest)
//        }
//
//        let stage = Stage(type: stageType, terrainID: id)
//
//        return stage.save(on: req.db)
//            .map {Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)}
//    }
//
//    func fetchAllStages(req: Request) throws -> EventLoopFuture<[Stage.Output]> {
//
//        return Stage.query(on: req.db)
//            .filter(\.$type == .georeferecing)
//            .all().map { stages in
//                let outputs = stages.map { stage in
//                    Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)
//                }
//                return outputs
//        }
//    }
//
//    func fetchStageById(req: Request) throws -> EventLoopFuture<Stage.Output> {
//
//        return Stage.find(req.parameters.get(stageRoute.route.parameters.stageId), on: req.db)
//            .unwrap(or: Abort(.notFound)).map {Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString , stageType: $0.type.rawValue)}
//    }
//
//    func fetchStageByTerrainID(req: Request) throws -> EventLoopFuture<Stage.Output> {
//
//        guard let terrainId = req.parameters.get(stageRoute.route.parameters.terrainId, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        return Stage.query(on: req.db)
//            .filter("terrain_id", .equal, terrainId).first().unwrap(or: Abort(.badRequest))
//            .map { Stage.Output(id: $0.id!.uuidString, terrain: $0.$terrain.id.uuidString, stageType: $0.type.rawValue)}
//    }
//
//    func deleteStageById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        guard let id = req.parameters.get(stageRoute.route.parameters.stageId, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        return Stage.find(id, on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap({$0.delete(on: req.db)})
//            .transform(to: .ok)
//    }
//
//    func updateStageById(req: Request) throws -> EventLoopFuture<Stage.Output> {
//        guard let id = req.parameters.get(stageRoute.route.parameters.stageId, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        let input = try req.content.decode(Stage.Input.self)
//        return Stage.find(id, on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { stage in
//                //Colocar aqui o que quiser mudar
//                return stage.save(on: req.db)
//                    .map { Stage.Output(id: stage.id!.uuidString, terrain: stage.$terrain.id.uuidString, stageType: stage.type.rawValue)}
//        }
//    }
//
//
//}

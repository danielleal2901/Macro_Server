//
//  DataManagerLogic.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor
import Foundation

typealias DataManagerLogic = TerrainManagement & StageManagement & OverviewManagement & StatusManagement

protocol TerrainManagement{
    func createTerrain(terrainInput: Terrain.Inoutput,req: Request) throws -> EventLoopFuture<Terrain>
    func updateTerrain(req: Request,newTerrain: Terrain.Inoutput) throws -> EventLoopFuture<Terrain>
    func deleteTerrain(req: Request,terrain: Terrain.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol StageManagement{
    func updateStage(req: Request,newStage: Stage.Inoutput) throws -> EventLoopFuture<Stage>
    func deleteStage(req: Request,stage: Stage.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol OverviewManagement{
    func updateOverview(req: Request,newOverview: Overview.Inoutput) throws -> EventLoopFuture<Overview>
    func deleteOverview(req: Request,overview: Overview.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol StatusManagement{
    func updateStatus(req: Request,newStatus: Status.Inoutput) throws -> EventLoopFuture<Status>
    func deleteStatus(req: Request,status: Status.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 21/09/20.
//

import Foundation
import Vapor

class StagesRoutesUtils {
    
    static func verifySimpleRoute(req: Request) throws -> Stage{

        guard let reqParameter = req.parameters.get(StageParameters.stageName.rawValue, as: String.self) else {
            throw Abort(.badRequest)
        }
        
        //Verifica se o tipo da url eh um tipo de stage
        guard let verifyStagePath = StageTypes(rawValue: reqParameter)  else {
            throw Abort(.badRequest)
        }
        
        //Verifica se consegue dar decode no input
        let input = try req.content.decode(Stage.Input.self)
        
        //Verifica se o id no input eh um uuid
        guard let id = UUID(uuidString: input.terrain) else {
            throw Abort(.badRequest)
        }
        
        //Verifica se o tipo da url eh igual ao tipo do content
        guard let stageType = StageTypes(rawValue: input.stageType), verifyStagePath == stageType else {
            throw Abort(.badRequest)
        }
        
        let stage = Stage(type: stageType, terrainID: id)
        
        return stage

    }
    
    static func verifyRouteWithStageId(req: Request) throws {
                    
        guard let stageType = req.parameters.get(StageParameters.stageName.rawValue, as: String.self) else {
            throw Abort(.badRequest)
        }

        //Verifica se a stage passada eh uma stage valida
        guard StageTypes(rawValue: stageType) != nil else {
            throw Abort(.badRequest)
        }
                
        return
    }
    
    static func verifyRouteWithTerrainId(req: Request) throws {

        
        
    }
    
//
//    static func verifyRouteWithTerrainId(path: String) throws -> StageTypes{
//        if let index = path.index(of: "stages/") {
//            let substring = path[index...]
//            let stagePath = String(substring)
//            guard let verifyStagePath = StageTypes(rawValue: stagePath) else {
//                throw Abort(.badRequest)
//            }
//        }
//        throw Abort(.badRequest)
//    }

    
    
}

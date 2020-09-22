//
//  File.swift
//  
//
//  Created by Daniel Leal on 21/09/20.
//

import Foundation
import Vapor

class StagesRoutesUtils {
    
    /// Method used to validate and get content from uploads request.
    /// - Parameter req: upload request
    /// - Throws: a possible error in validation
    /// - Returns: a stage get from request content
    static func verifyUploadRoutes(req: Request) throws -> Stage{
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
    
    /// Method used to validate and get a stage type from data request
    /// - Parameter req: data request
    /// - Throws: possible error in validation
    /// - Returns: returns a stage type getted from url
    static func verifyDataRoutes(req: Request) throws -> StageTypes{
        
        //Verifica se consegue pegar o parametro da url
        guard let reqParameter = req.parameters.get(StageParameters.stageName.rawValue, as: String.self) else {
            throw Abort(.badRequest)
        }
        
        //Verifica se o tipo informado no parametro da url eh um tipo de stage
        guard let verifyStagePath = StageTypes(rawValue: reqParameter)  else {
            throw Abort(.badRequest)
        }
        
        return verifyStagePath
    }
 
    
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 21/09/20.
//

import Foundation
import Vapor

enum StageRoutesType {
    case simple
    case stageId
    case terrainId
}

class StagesRoutesUtils {
    
    static func verifyStageRequest(req: Request) throws -> StageTypes {
        let path = req.url.path
        let lowerBound = path.index(path.startIndex, offsetBy: 8)
        let upperBound = path.index(path.startIndex, offsetBy: path.count)
        let stagePath = String(path[lowerBound..<upperBound])
        
        guard let verifyStagePath = StageTypes(rawValue: stagePath) else {
            throw Abort(.badRequest)
        }
        
        return verifyStagePath
    }
    
}

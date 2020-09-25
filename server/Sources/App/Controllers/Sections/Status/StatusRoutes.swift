//
//  File.swift
//  
//
//  Created by Daniel Leal on 24/09/20.
//

import Foundation
import Vapor

enum StatusRoutes: String {
    case main = "status"
    case id = ":statusId"
    case withStage = "stage"
    case stageId = ":stageId"
    
    static func getPathComponent(_ route: StatusRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum StatusParameters : String {
    case stageName = "stageName"
    case statusId = "statusId"
    case stageId = "stageId"
}

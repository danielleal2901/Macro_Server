//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 09/11/20.
//


import Foundation
import Vapor

enum MarkerRoutes: String{
    case main = "markers"
    case id = ":markerId"
    case status = ":status"
    case statusId = ":statusId"
    
    static func getPathComponent(_ route: MarkerRoutes) -> PathComponent{
        return PathComponent(stringLiteral: route.rawValue)
    }
    
}

enum MarkerParameters: String{
    case idMarker = "markerId"
    case idStatus = "statusId"
}

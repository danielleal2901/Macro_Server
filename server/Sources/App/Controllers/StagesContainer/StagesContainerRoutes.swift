//
//  File.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Vapor

enum StagesContainerRoutes: String {
    case main = "containers"
    case id = ":containerId"
    case withType = "type"
    case containerType = ":containerType"
    
    static func getPathComponent(_ route: StagesContainerRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum StagesContainerParameters: String {
    case idContainer = "containerId"
    case containerType = "containerType"
}

//
//  File.swift
//  
//
//  Created by Jose Deyvid on 15/10/20.
//

import Vapor

enum UserRoutes: String {
    case main = "users"
    case id = ":userId"
    
    static func getPathComponent(_ route: UserRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum UserParameters: String {
    case idUser = "userId"
}
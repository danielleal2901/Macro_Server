//
//  File.swift
//  
//
//  Created by Jose Deyvid on 20/10/20.
//

import Vapor

enum UserRoutes: String {
    case main = "users"
    case id = ":userId"
    case employeeToken = ":token"

    static func getPathComponent(_ route: UserRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum UserParameters: String {
    case idUser = "userId"
    case employeeToken = "token"
}

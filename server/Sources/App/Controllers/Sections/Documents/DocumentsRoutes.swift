//
//  File.swift
//  
//
//  Created by Jose Deyvid on 18/09/20.
//

import Vapor

enum DocumentsRoutes: String {
    case main = "documents"
    case id = ":documentId"
    
    static func getPathComponent(_ route: DocumentsRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

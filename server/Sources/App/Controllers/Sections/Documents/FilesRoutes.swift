//
//  File.swift
//  
//
//  Created by Daniel Leal on 05/10/20.
//

import Foundation
import Vapor

enum FilesRoutes: String {
    case main = "files"
    case id = ":fileId"
    case withDocument = "document"
    case documentId = ":documentId"
    case withItem = "item"
    case itemId = ":itemId"
    
    static func getPathComponent(_ route: FilesRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum FilesParameters : String {
    case documentId = "documentId"
    case itemId = "itemId"
    case id = "fileId"
}

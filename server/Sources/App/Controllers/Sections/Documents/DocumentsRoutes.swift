//
//  File.swift
//  
//
//  Created by Jose Deyvid on 18/09/20.
//
import Foundation
import Vapor

enum DocumentRoutes: String {
    case main = "documents"
    case id = ":documentId"
    case withStage = "stage"
    case stageId = ":stageId"
    case sectionId = ":sectionId"
    case itemId = ":itemId"
    
    static func getPathComponent(_ route: DocumentRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum DocumentParameters : String {
    case stageName = "stageName"
    case documentId = "documentId"
    case stageId = "stageId"
    case sectionId = "sectionId"
    case itemId = "itemId"
}

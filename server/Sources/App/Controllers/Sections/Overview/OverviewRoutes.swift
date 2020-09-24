//
//  File.swift
//
//
//  Created by Daniel Leal on 12/09/20.
//

import Vapor

enum OverviewRoutes: String {
    case main = "overviews"
    case id = ":overviewId"
    case withStage = "stage"
    case stageId = ":stageId"
    
    static func getPathComponent(_ route: OverviewRoutes) -> PathComponent {
        return PathComponent(stringLiteral: route.rawValue)
    }
}

enum OverviewParameters : String {
    case stageName = "stageName"
    case overviewId = "overviewId"
    case stageId = "stageId"
}


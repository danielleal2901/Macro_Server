//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Foundation
import Vapor
import Fluent

class GeoController: RouteCollection, StageRoutesProtocol {
    let stageRoute: StageRoutes = StageRoutes(stage: .geo)
    
    func boot(routes: RoutesBuilder) throws {
        setupRoutesBuilder(routes: routes)
    }
}

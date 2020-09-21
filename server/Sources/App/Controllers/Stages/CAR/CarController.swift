//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

class CarController: RouteCollection, StageRoutesProtocol {
    let stageRoute: StageRoutes = StageRoutes(stage: .car)
    
    func boot(routes: RoutesBuilder) throws {
        setupRoutesBuilder(routes: routes)
    }
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

class EvaluationController: RouteCollection, StageRoutesProtocol {
    let stageRoute: StageRoutes = StageRoutes(stage: .evaluation)

    func boot(routes: RoutesBuilder) throws {
        setupRoutesBuilder(routes: routes)
    }
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

final class Stage: Model, Content {
    
    static let schema = "stages"
    
    struct Input: Content {
        let terrain: String
        let stageType: StageTypes
    }
    
    struct Output: Content {
        let id: String
        let terrain: String
        let stageType: String
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "terrain_id")
    var terrain: Terrain
    
    @Enum (key: "type")
    var type: StageTypes
    
    init() {}
    
    init(type: StageTypes, terrainID: UUID) {
        self.type = type
        self.$terrain.id = terrainID
        self.id = UUID()
    }
}

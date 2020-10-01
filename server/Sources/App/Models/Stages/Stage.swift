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
    
    struct Inoutput: Content {
        let id: UUID
        let terrain: UUID
        let stageType: StageTypes
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "terrain_id")
    var terrain: Terrain
    
    @Enum (key: "type")
    var type: StageTypes
    
    init() {}
    
    init(id: UUID = UUID(), type: StageTypes, terrainID: UUID) {
        self.type = type
        self.$terrain.id = terrainID
        self.id = id
    }
}

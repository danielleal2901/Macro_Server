//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Foundation
import Vapor
import Fluent

final class Georeferecing: Model, Content {
    
    static let schema = "georeferecings"
    
    struct Input: Content {
        let name: String
        let terrain: String
    }
    
    struct Output: Content {
        let id: String
        let name: String
        let terrain: String
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "terrain_id")
    var terrain: Terrain
    
    @Field(key: "name")
    var name: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, terrainID: UUID) {
        self.name = name
        self.$terrain.id = terrainID
    }
}

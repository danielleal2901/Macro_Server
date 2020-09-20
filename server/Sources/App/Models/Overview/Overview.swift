//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

final class Overview: Model, Content {
    
    static let schema = "overviews"
    
    struct Input: Content {
        let stage: String
        let content: [OverviewSection]
    }
    
    struct Output: Content {
        let id: String
        let stage: String
        let content: [OverviewSection]
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "geo_id")
    var stage: Terrain
    
    @Field(key: "name")
    var name: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, terrainID: UUID) {
        self.name = name
        self.$terrain.id = terrainID
    }
}

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
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "terrain_id")
    var terreno: Terrain
    
    @Field(key: "name")
    var name: String
    
    init() {}
    
    init(name: String, terrenoID: UUID) {
        self.id = UUID()
        self.$terreno.id = terrenoID
        self.name = name
    }
}

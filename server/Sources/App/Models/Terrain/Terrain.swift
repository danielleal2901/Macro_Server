//
//  File.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Foundation
import Vapor
import Fluent


final class Terrain: Model, Content {
    
    struct Inoutput: Content {
        let name: String
        let stages: [StageTypes]
        var id: String
    }

    static let schema = "terrains"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "stages_names")
    var stages: [String]
    
    init() {}
    
    init(id: UUID = UUID(), name: String, stages: [String]) {
        self.id = id
        self.name = name
        self.stages = stages
    }
}

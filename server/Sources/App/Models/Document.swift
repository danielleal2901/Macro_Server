//
//  File.swift
//  
//
//  Created by Jose Deyvid on 18/09/20.
//

import Foundation
import Vapor
import Fluent

final class Document: Model, Content {
    
    static let schema = "documents"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "terrain_id")
    var terreno: Terrain
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "format")
    var format: String
    
    init() {}
    
    init(name: String, terrenoID: UUID, format: String) {
        self.id = UUID()
        self.$terreno.id = terrenoID
        self.name = name
        self.format = format
    }
}

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
    
    @Parent(key: "stage_id")
    var stage: Stage
    
    @Field(key: "format")
    var format: String
    
    init() {}
    
    init(stageId: UUID, format: String) {
        self.id = UUID()
        self.$stage.id = stageId
        self.format = format
    }
}

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
    
    struct Inoutput: Content {
        let id: UUID
        let stageId: UUID
        let sections: [DocumentSection]
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "stage_id")
    var stage: Stage
    
    @Field(key: "sections")
    var sections: [DocumentSection]
    
    init() {}
    
    init(id: UUID = UUID(), stageId: UUID, sections: [DocumentSection]) {
        self.id = id
        self.$stage.id = stageId
        self.sections = sections
    }
}

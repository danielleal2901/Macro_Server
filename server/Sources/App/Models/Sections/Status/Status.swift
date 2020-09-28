//
//  File.swift
//  
//
//  Created by Daniel Leal on 24/09/20.
//

import Foundation
import Vapor
import Fluent

final class Status: Model, Content {
    
    static let schema = "status"
    
    struct Inoutput: Content {
        let id: String
        let stageId: String
        let sections: [StatusSection]
    }
            
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "stage_id")
    var stage: Stage
    
    @Field(key: "sections")
    var sections: [StatusSection]
    
    init() {}
     
    init(stageId: UUID, sections: [StatusSection]) {
        self.id = UUID()
        self.$stage.id = stageId
        self.sections = sections
    }
}

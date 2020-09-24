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
        let stageId: String
        let sections: [OverviewSection]
    }
    
    struct Output: Content {
        let id: String
        let stageId: String
        let sections: [OverviewSection]
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "stage_id")
    var stage: Stage
    
    @Field(key: "sections")
    var sections: [OverviewSection]
    
    init() {}
     
    init(stageId: UUID, sections: [OverviewSection]) {
        self.id = UUID()
        self.$stage.id = stageId
        self.sections = sections
    }
}

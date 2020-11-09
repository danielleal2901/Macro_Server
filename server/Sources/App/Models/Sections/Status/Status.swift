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
        let id: UUID
        let stageId: UUID
        let tasks: [Task]        
    }

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "stage_id")
    var stage: Stage
    
    @Field(key: "tasks")
    var tasks: [Task]
        
    
    init() {}
     
    init(id: UUID = UUID(), stageId: UUID, tasks: [Task]) {
        self.id = id
        self.$stage.id = stageId
        self.tasks = tasks
    }
}

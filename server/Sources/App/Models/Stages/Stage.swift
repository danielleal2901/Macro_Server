//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor
import Fluent

final class Stage: Model, Content {
    
    static let schema = "stages"
    
    struct Inoutput: Content {
        let id: UUID
        let container: UUID
        let stageType: StageTypes
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "container_id")
    var container: StagesContainer
    
    @Enum (key: "type")
    var type: StageTypes
    
    init() {}
    
    init(id: UUID = UUID(), type: StageTypes, containerId: UUID) {
        self.type = type
        self.$container.id = containerId
        self.id = id
    }
}

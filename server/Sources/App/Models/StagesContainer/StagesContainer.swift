//
//  File.swift
//  
//
//  Created by Antonio Carlos on 11/09/20.
//

import Foundation
import Vapor
import Fluent

final class StagesContainer: Model, Content {
    
    struct Inoutput: Content {
        let type: StagesContainerTypes
        let stages: [StageTypes]
        let id: UUID
        let farmId: UUID
        let name: String
    }
    
    static let schema = "stagesContainer"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "farm_id")
    var farm: Farm
    
    @Enum(key: "type")
    var type: StagesContainerTypes
    
    @Field(key: "stages_names")
    var stages: [String]
    
    @Field(key: "name")
    var name: String
    
    init() {}
    
    init(id: UUID = UUID(), type: StagesContainerTypes, stages: [String], farmId: UUID, name: String) {
        self.id = id
        self.type = type
        self.stages = stages
        self.$farm.id = farmId
        self.name = name
    }
}

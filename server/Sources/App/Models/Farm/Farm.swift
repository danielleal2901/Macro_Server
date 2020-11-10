//
//  File.swift
//
//
//  Created by Daniel Leal on 20/10/20.
//

import Foundation
import Vapor
import Fluent

final class Farm: Model, Content {
    
    static let schema = "farms"
    
    struct Inoutput: Content {
        let id: UUID
        let name: String
        let teamId: UUID
        let icon: Data
        let desc: String
    }

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "teamId")
    var teamId: UUID
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "desc")
    var desc: String
    
    @Field(key: "icon")
    var icon: Data
    
    init() {}
     
    init(id: UUID? = nil, teamId: UUID, name: String, desc: String,icon: Data) {
        self.id = id
        self.teamId = teamId
        self.name = name
        self.desc = desc
        self.icon = icon
    }
}

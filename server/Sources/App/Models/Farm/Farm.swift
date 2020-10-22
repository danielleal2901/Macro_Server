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
        let teamId: UUID
        let name: String
        let desc: String
    }

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "team_Id")
    var teamId: UUID
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "desc")
    var desc: String
    
    init() {}
     
    init(id: UUID = UUID(), teamId: UUID, name: String, desc: String) {
        self.id = id
        self.teamId = teamId
        self.name = name
        self.desc = desc
    }
}

//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 01/10/20.
//

import Fluent
import Vapor

final class WSUserState: Model, Content {
   
    static let schema = "users_states"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String?
    
    @Field(key: "photo")
    var photo: String?
    
    @Field(key: "respUserID")
    var respUserID: UUID
    
    @Field(key: "destTeamID")
    var destTeamID: UUID
    
    @Field(key: "stageID")
    var stageID: UUID
    
    init() {}
       
    init(_ id: UUID,_ name: String, _ photo: String,_ resp: UUID,_ dest: UUID,_ stage: UUID){
        self.id = id
        self.name = name
        self.photo = photo
        self.respUserID = resp
        self.destTeamID = dest
        self.stageID = stage
    }
        
}

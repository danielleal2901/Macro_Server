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
    var name: String
    
    @Field(key: "photo")
    var photo: String
    
    @Field(key: "terrainID")
    var terrainID: UUID
    
    @Field(key: "respUserID")
    var respUserID: UUID
    
    @Field(key: "destTeamID")
    var destTeamID: UUID
    
    @Enum (key: "stageType")
    var stageType: StageTypes
    
    init() {}
       
    init(_ id: UUID,_ name: String, _ photo: String,_ terrain: UUID,_ resp: UUID,_ dest: UUID,_ stage: StageTypes){
        self.id = id
        self.name = name
        self.photo = photo
        self.terrainID = terrain
        self.respUserID = resp
        self.destTeamID = dest
        self.stageType = stage
    }
        
}

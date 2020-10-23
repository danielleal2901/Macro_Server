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
    
    @Field(key: "containerID")
    var containerID: UUID
    
    init() {}
       
    init(_ resp: UUID,_ dest: UUID,_ container: UUID){
        self.respUserID = resp
        self.destTeamID = dest
        self.containerID = container
    }
        
}

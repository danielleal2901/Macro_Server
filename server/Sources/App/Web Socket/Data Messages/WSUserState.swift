//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 01/10/20.
//

import Fluent
import Vapor

struct WSUserEntity: Codable{
    var respUserID: String
    var destTeamID: String
    var stageID: String
}

final class WSUserState: Model, Content {
   
    static let schema = "users_states"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "respUserID")
    var respUserID: UUID
    
    @Field(key: "destTeamID")
    var destTeamID: UUID
    
    @Field(key: "stageID")
    var stageID: UUID
    
    init() {}
       
    init(_ resp: UUID,_ dest: UUID,_ stage: UUID){
        self.respUserID = resp
        self.destTeamID = dest
        self.stageID = stage
    }
        
}

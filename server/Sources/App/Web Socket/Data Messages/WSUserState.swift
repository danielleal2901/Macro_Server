////
////  File.swift
////
////
////  Created by Guilherme Martins Dalosto de Oliveira on 01/10/20.
////
//
//import Fluent
//import Vapor
//
//final class WSUserState: Model, Content {
//
//    static let schema = "users_states"
//
//    @ID(key: .id)
//    var id: UUID?
//
//    @Field(key: "respUserID")
//    var respUserID: UUID
//
//    @Field(key: "destTeamID")
//    var destTeamID: UUID
//
//    @Field(key: "containerID")
//    var containerID: UUID
//
//    init() {}
//
//    init(_ id: UUID = UUID(), _ resp: UUID,_ dest: UUID,_ container: UUID){
//        self.id = id
//        self.containerID = container
//        self.respUserID = resp
//        self.destTeamID = dest
//    }
//
//}

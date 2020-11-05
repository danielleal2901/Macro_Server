////
////  CreateUserState.swift
////
////
////  Created by Guilherme Martins Dalosto de Oliveira on 01/10/20.
////
//
//import Fluent
//import Vapor
//
//struct CreateUserState: Migration {
//
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        database.schema("users_states")
//            .id()
//            .field("respUserID", .uuid, .required)
//            .field("containerID", .uuid, .required)
//            .field("destTeamID", .uuid, .required)
//            .foreignKey("respUserID", references: "users","id")
//            .foreignKey("containerID", references: "stagesContainer","id")
//            .create()
//    }
//
//
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        database.schema("users").delete()
//    }
//}

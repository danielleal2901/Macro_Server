//
//  User.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "user_type")
    var userType: Int

    init() { }

    init(id: UUID? = nil, name: String, email: String, passwordHash: String, userType: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.userType = userType
    }
}


extension User{
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

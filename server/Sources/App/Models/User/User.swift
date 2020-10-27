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

    @Field(key: "password")
    var password: String
    
    @Field(key: "is_admin")
    var isAdmin: Bool
    
    @Field(key: "image")
    var image: Data
    
    @Parent(key: "team_id")
    var team: Team

    init() { }

    init(id: UUID? = nil, name: String, email: String, password: String, isAdmin: Bool) throws {
        self.id = id
        self.name = name
        self.email = email
        self.password = try Bcrypt.hash(password)
        self.isAdmin = isAdmin
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(UUID.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.email = try values.decode(String.self, forKey: .email)
        self.password = try Bcrypt.hash(values.decode(String.self, forKey: .password))
        self.isAdmin = try values.decode(Bool.self, forKey: .isAdmin)
        self.image = try values.decode(Data.self, forKey: .image)
        if self.isAdmin {
            self.$team.id = try values.decode(UUID.self, forKey: .teamId)
        }
    }
}


extension User{

    private enum CodingKeys: String, CodingKey{
        case id
        case name
        case email
        case password
        case isAdmin
        case teamId = "teamId"
        case employeeToken
        case guestToken
        case image
    }
    
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

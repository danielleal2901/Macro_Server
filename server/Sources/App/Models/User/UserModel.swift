//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor

struct AuthEntity: Codable {
    var id: String?
    var name: String
    var email: String
    var password: String
    var userType: Int
    
    init(name: String,email: String,password: String, userType: Int) {
        self.name = name
        self.email = email
        self.password = password
        self.userType = userType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self,forKey: .name)
        email = try values.decode(String.self,forKey: .email)
        password = try values.decode(String.self,forKey: .password)
        userType = try values.decode(Int.self, forKey: .userType)
    }
    
}

extension AuthEntity: Validatable{
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self,is: !.empty)
        validations.add("email", as: String.self,is: .email)
        validations.add("password", as: String.self,is: .count(8...))
    }
}

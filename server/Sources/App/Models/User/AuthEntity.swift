//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor
import Fluent

class AuthEntity: Codable {
    var email: String
    var password: String
    
    init(email: String,password: String) {
        self.email = email
        self.password = password
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decode(String.self,forKey: .email)
        password = try values.decode(String.self,forKey: .password)
    }
    
}

extension AuthEntity: Validatable{
    static func validations(_ validations: inout Validations) {        
        validations.add("email", as: String.self,is: .email)
        validations.add("password", as: String.self,is: .count(8...))
    }
}

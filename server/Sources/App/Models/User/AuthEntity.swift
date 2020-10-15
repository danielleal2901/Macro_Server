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
    var confirmPassword: String
    
    init(name: String,email: String,password: String,confirmPassword: String) {
        self.name = name
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self,forKey: .name)
        email = try values.decode(String.self,forKey: .email)
        password = try values.decode(String.self,forKey: .password)
        confirmPassword = try values.decode(String.self,forKey: .confirmPassword)        
    }
    
}

extension AuthEntity: Validatable{
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self,is: !.empty)
        validations.add("email", as: String.self,is: .email)
        validations.add("password", as: String.self,is: .count(8...))
    }


}

//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor

struct UserModel: Codable {
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
}

extension UserModel: Validatable{
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self,is: !.empty)
        validations.add("email", as: String.self,is: .email)
        validations.add("password", as: String.self,is: .count(8...))
    }
    
    
}

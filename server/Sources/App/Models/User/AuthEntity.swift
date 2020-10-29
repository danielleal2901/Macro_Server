//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor
import Fluent

class AuthEntity: Authenticatable, Codable {
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

//extension AuthEntity: ModelAuthenticatable{
//    static let usernameKey = \AuthEntity.$email
//    static let passwordHashKey = \AuthEntity.$password
//
//    func verify(password: String) throws -> Bool {
//        try Bcrypt.verify(password, created: self.password)
//    }
//}

extension AuthEntity: BasicAuthenticator {
    typealias User = App.AuthEntity

    func authenticate(basic: BasicAuthorization, for request: Request) -> EventLoopFuture<Void> {
        if basic.username == self.email && basic.password == self.password {
            request.auth.login(AuthEntity(email: self.email, password: self.password))
        }
        return request.eventLoop.makeSucceededFuture(())
    }
}

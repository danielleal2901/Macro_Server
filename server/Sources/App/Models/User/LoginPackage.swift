//
//  File.swift
//  
//
//  Created by Antonio Carlos on 11/11/20.
//

import Foundation
import Vapor

struct LoginPackage: Content {
    let id: UUID
    let user: UserResponse
    let userToken: UserToken
    
    init(id: UUID = UUID(), user: UserResponse, userToken: UserToken) {
        self.id = id
        self.user = user
        self.userToken = userToken
    }
}

//
//  File.swift
//  
//
//  Created by Antonio Carlos on 27/10/20.
//

import Foundation
import Vapor

struct UserResponse: Content {
    let id: UUID
    let name: String
    let email: String
    let password: String
    let isAdmin: Bool
    let image: Data
    let teamId: UUID
}

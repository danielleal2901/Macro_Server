//
//  File.swift
//  
//
//  Created by Antonio Carlos on 16/10/20.
//

import Vapor

struct TeamRequest: Content {
    var id: UUID
    var name: String
    var description: String
    var employeeToken: String
    var guestToken: String
    var image: Data
    var admin: UUID
}

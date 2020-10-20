//
//  File.swift
//  
//
//  Created by Antonio Carlos on 16/10/20.
//

import Vapor

struct TeamRequest: Content {
    var name: String
    var description: String
    var image: Data
}

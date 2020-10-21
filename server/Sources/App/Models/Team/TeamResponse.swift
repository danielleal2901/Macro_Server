//
//  File.swift
//  
//
//  Created by Antonio Carlos on 20/10/20.
//

import Foundation
import Vapor

struct TeamResponse: Content {
    let id: UUID?
    let name: String
    let description: String
    let image: Data
}

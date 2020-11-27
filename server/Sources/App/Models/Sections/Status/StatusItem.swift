//
//  File.swift
//  
//
//  Created by Daniel Leal on 24/09/20.
//

import Foundation
import Vapor

struct Task: Content {
    let id: UUID
    let title: String    
    var columnTitle: String
    let tags: [UUID]
    let resp: [UUID]
    var done: Bool = false
}

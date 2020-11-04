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
    let status: TaskStatus
    let tags: [Marker]
    let resp: [UUID]
}

struct Marker: Codable{
    var id = UUID()
    var title: String
    var color: [Double]
    var isSelected: Bool = false
}

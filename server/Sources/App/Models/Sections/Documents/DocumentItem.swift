//
//  File.swift
//  
//
//  Created by Daniel Leal on 02/10/20.
//

import Foundation
import Vapor

struct DocumentItem: Content, Equatable {
    let id: UUID
    let format: String
    let name: String
    let dateAdded: Date
}

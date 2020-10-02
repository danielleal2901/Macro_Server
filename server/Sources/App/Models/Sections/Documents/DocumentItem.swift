//
//  File.swift
//  
//
//  Created by Daniel Leal on 02/10/20.
//

import Foundation
import Vapor

struct DocumentItem: Content, Equatable {
    let name: String
    var content: Data
    let format: String
}

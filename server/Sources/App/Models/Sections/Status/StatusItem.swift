//
//  File.swift
//  
//
//  Created by Daniel Leal on 24/09/20.
//

import Foundation
import Vapor

struct StatusItem: Content {
    let key: String
    let done: Bool
}

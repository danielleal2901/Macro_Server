//
//  File.swift
//  
//
//  Created by Daniel Leal on 24/09/20.
//

import Foundation
import Vapor

struct StatusSection: Content {
    let name: String
    let items: [StatusItem]
}


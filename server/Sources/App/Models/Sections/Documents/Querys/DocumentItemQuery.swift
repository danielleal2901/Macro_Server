//
//  File.swift
//  
//
//  Created by Daniel Leal on 02/10/20.
//

import Foundation
import Vapor

struct DocumentItemQuery: Content {
    let itemName: String
    let sectionName: String
}

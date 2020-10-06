//
//  File.swift
//  
//
//  Created by Daniel Leal on 02/10/20.
//

import Foundation
import Vapor

struct DocumentSection: Content {
    let name: String
    var items: [DocumentItem]
}

//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation
import Vapor

struct OverviewSection: Content {
    let name: String
    let items: [OverviewItem]
}

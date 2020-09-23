//
//  File.swift
//  
//
//  Created by Daniel Leal on 20/09/20.
//

import Foundation

enum StageTypes : String, Codable{
    case georeferencing = "georeferencing"
    case car = "car"
    case evaluation = "evaluation"
    case enviroment = "enviroment"
    case register = "register"
    case resident = "resident"
}

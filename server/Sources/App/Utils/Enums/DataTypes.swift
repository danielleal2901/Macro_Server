//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation


/// Using for identify current data requests (disabled for a while)
enum DataTypes : String, Codable{
    case document = "document"
    case container =  "container"
    case overview = "overview"
    case stage = "stage"
    case status = "status"
    case files = "files"
    case users = "users"
    case teams = "teams"
    case loginOperations
}




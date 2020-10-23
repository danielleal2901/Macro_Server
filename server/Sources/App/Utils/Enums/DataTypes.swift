//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation


/// Using for identify current data requests (disabled for a while)
enum DataTypes: String, Codable{
    case container = "container"
    case status = "status"
    case document = "document"
    case overview = "overview"
    case stage = "stage"
    case file = "files"
    
}


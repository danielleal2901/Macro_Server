//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 10/11/20.
//

import Foundation

struct ResetPackage: Codable{
    let id: UUID
    let email: String
    let token: String
    let password: String
}

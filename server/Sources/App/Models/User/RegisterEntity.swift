//
//  File.swift
//
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor

class RegisterEntity: Codable{
    //MARK: Variables
    // Colocar foto
    let name: String
    let email: String
    let password: String
    
    //MARK: Initializer
    init(_ name: String,_ email: String,_ password: String){
        self.name = name
        self.email = email
        self.password = password        
    }
}


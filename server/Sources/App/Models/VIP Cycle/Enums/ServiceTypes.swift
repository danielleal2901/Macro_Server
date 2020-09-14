//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation

enum ServiceTypes{
    struct Connection{
        var response: Bool
    }
    
    struct Dispatch{
        struct Request{
            var data: DataTypes
        }
        var response: Bool
    }
    
    struct Receive{
        struct Request{
            var data: DataTypes
        }
        var response: Bool
    }
}


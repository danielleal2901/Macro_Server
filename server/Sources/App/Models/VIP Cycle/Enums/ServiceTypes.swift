//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation

enum ServiceTypes{
    struct Connection{
        struct Response{
            var status: Bool
        }
        struct activeSession{
            var sessionID: Int
        }
    }
    
    struct Dispatch{
        struct Request{
            var data: DataTypes
        }
        struct Response{
            var actionStatus: ActionTypes
        }
    }
    
    struct Receive{
        struct Request{
            var data: DataTypes
        }
        struct Response{
            var actionStatus: ActionTypes
        }
    }
}

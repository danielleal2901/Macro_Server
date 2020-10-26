//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation

/// Service types of Connection currently of Web Sockets
enum ServiceTypes{
    
    /// Connection Status
    struct Connection{
        /// Response of Connection Request
        struct Response{
            var status: Bool
        }
        /// Active Session ID for identifications
        struct activeSession{
            var sessionID: Int
        }
    }
    
    /// Dispatch Status
    struct Dispatch{
         /// Data of Dispatch Request
        struct Request{
            var data: WSDataPackage // Change to DataType
        }
        /// Response of Dispatch Request
        struct Response{
            var actionStatus: StateTypes
        }
        
        struct Broadcast{
            
        }
    }
    
    /// Receive Status
    struct Receive{
        /// Data of Receive Request
        struct Request{
            // Change to proper ID var
            var data: WSDataPackage
        }
        /// Response of Receive Request
        struct Response{
            var dataReceived: Data?
            var actionStatus: StateTypes
        }
    }
}


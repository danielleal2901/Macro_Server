//
//  TeamConnection.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

internal struct TeamConnection{
    // MARK - Variables
    internal var name: String
    internal var teamName: String
    internal var webSocket: WebSocket
}

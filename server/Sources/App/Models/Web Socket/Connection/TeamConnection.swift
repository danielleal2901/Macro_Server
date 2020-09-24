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
    internal var userID: UUID
    internal var teamID: UUID
    internal var webSocket: WebSocket
}

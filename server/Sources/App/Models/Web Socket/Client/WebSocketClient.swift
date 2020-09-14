//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Vapor

open class WebSocketClient {
    open var id: UUID
    open var socket: WebSocket

    public init(id: UUID, socket: WebSocket) {
        self.id = id
        self.socket = socket
    }
}

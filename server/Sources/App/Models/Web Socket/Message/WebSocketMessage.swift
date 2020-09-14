//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Vapor

struct Connect: Codable {
    let connect: Bool
}

struct WebsocketMessage<T: Codable>: Codable {
    let client: UUID
    let data: T
}

extension ByteBuffer {
    func decodeWebsocketMessage<T: Codable>(_ type: T.Type) -> WebsocketMessage<T>? {
        try? JSONDecoder().decode(WebsocketMessage<T>.self, from: self)
    }
}

final class PlayerClient: WebSocketClient {
    
    public init(id: UUID, socket: WebSocket, status: Status) {
        super.init(id: id, socket: socket)
    }
}

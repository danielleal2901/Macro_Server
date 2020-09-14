//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Vapor

class NetworkManager: WebSocketLogic{
    func connect() {
         let webSocketDelegate = WebSocket()
               let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
               let url = URL(string: "wss://echo.websocket.org")!
               let webSocketTask = session.webSocketTask(with: url)
               webSocketTask.resume()
               pingar(wb: webSocketTask)
    }
    
    func ping() {
        <#code#>
    }
    
    func send() {
        <#code#>
    }
    
    func receive() {
        <#code#>
    }
    
    
}

//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Vapor

class NetworkManager: WebSocketLogic{
    typealias Builder =
    
    let url = URL(string: "wss://echo.websocket.org")!
    let webSocketDelegate: WebSocketDelegate
    let socketSession: URLSession
    let webSocketTask: URLSessionWebSocketTask
    
    init(){
        webSocketDelegate = WebSocketDelegate()
        socketSession = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
        webSocketTask = socketSession.webSocketTask(with: url)
        
    }
        
    func connect(){
        webSocketTask.resume()
        ping()
    }
    
    func send() {
        print("Sending a Message to Server")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.send(wb: wb)
            self.receive(wb: wb)
            wb.send(.string("Lorem Ipsum Gui")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }
    
    func receive() {
        wb.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Data received from Server: \(data)")
                case .string(let text):
                    print("Text received from Server: \(text)")
                }
            case .failure(let error):
                print("Error when receiving \(error)")
            }
            self.receive(wb: wb)
        }
    }
    
    
    func ping() {
        wb.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Pinged with Success")
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.pingar(wb: wb)
                    self.send(wb: wb)
                }
            }
        }
    }
    
    
    
    
    
}

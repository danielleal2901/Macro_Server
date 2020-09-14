//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Vapor

class NetworkManager: WebSocketLogic{
    typealias Builder = (WebSocketDelegate,URLSession,URLSessionWebSocketTask) -> NetworkManager
    
    let url = URL(string: "wss://echo.websocket.org")!
    private let webSocketDelegate: WebSocketDelegate
    private let socketSession: URLSession
    private let webSocketTask: URLSessionWebSocketTask
    
    // Currently Builder Functions, for Testing
    init(){
        webSocketDelegate = WebSocketDelegate()
        socketSession = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
        webSocketTask = socketSession.webSocketTask(with: url)
    }
        
    func connect(){
        webSocketTask.resume()
        ping()
    }
    
    func send<Type>(data: Type) {
        print("Sending a Message to Server")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.send()
            self.receive()
            self.webSocketTask.send(.string("Lorem Ipsum Gui")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }
    
    func receive<Destination>(destination: Destination) {
        self.webSocketTask.receive { result in
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
            self.receive()
        }
    }
    
    
    func ping() ->  {
        self.webSocketTask.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Pinged with Success")
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.ping()
                    self.send()
                }
            }
        }
    }
    
    
    
    
    
}

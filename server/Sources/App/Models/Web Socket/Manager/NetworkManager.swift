//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Vapor

class NetworkManager: WebSocketLogic{

    typealias Builder = (WebSocketDelegate,URLSession,URLSessionWebSocketTask) -> NetworkManager
    
    let urls = URL(string: "wss://echo.websocket.org")!
    private let webSocketDelegate: WebSocketDelegate
    private let socketSession: URLSession
    private var webSocketTask: URLSessionWebSocketTask!
    
    // Currently Builder Functions, for Testing
    init(){
        webSocketDelegate = WebSocketDelegate()
        socketSession = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())        
    //    webSocketTask = socketSession.webSocketTask(with: url)
    }
        
    @discardableResult
    func connect(url: URL) -> ServiceTypes.Connection?{
        webSocketTask = socketSession.webSocketTask(with: urls)
        webSocketTask.resume()
        return nil
    }

    func disconnect(activeSession: String) -> ServiceTypes.Connection? {
        // add Logic of Active Session
        webSocketTask.cancel()
        return nil
    }
    
    func suspend(activeSession: String) -> ServiceTypes.Connection? {
        // add Logic of Active Session
        webSocketTask.suspend()
        return nil
    }
    
    @discardableResult
    func send<SendType>(data: SendType) -> ServiceTypes.Dispatch.Response? {
        print("Sending a Message to Server")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.send(data: "welcome")
            self.receive(destination: "")
            // Fix current casting
            self.webSocketTask.send(.string(data as! String)) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
        return nil
    }
    
    @discardableResult
    func receive<Destination>(destination: Destination?) -> ServiceTypes.Receive.Response? {
        self.webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Data received from Server: \(data)")
                case .string(let text):
                    print("Text received from Server: \(text)")
                @unknown default:
                    fatalError()
                }
            case .failure(let error):
                print("Error when receiving \(error)")
            }
            self.receive(destination: "")
        }
        
        return nil
    }
    
    
    func ping()  {
        self.webSocketTask.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Pinged with Success")
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.ping()
                    self.send(data: "message")
                }
            }
        }
    }
    
    
    
    
    
}

//
//  WebSocketDelegate.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Vapor

class WebSocketDelegate: NSObject, URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        print(session)
        receive(wt: webSocketTask)
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
    
    func receive(wt: URLSessionWebSocketTask){
        print("Receiving...")
        wt.receive { result in
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
            self.receive(wt: wt)
            
        }
    }
    
    
}

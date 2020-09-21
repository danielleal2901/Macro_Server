//
//  DataController.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

internal class DataController{
    
    var dataSample = SpecifiedData(id: 0)
    
    internal func addData(data: ServiceTypes.Dispatch.Request){
        DataManager.shared.appendData(request: .init(data:"" )) { (response) in
            
            
            
        }
    }
    
    internal func fetchData(sessionID: Request,recordID: ServiceTypes.Receive.Request,completion: @escaping (ServiceTypes.Receive.Response) -> ()){
        DataManager.shared.fetchData(sessionRequest: sessionID,dataRequest: recordID) { (response) in
            completion(response ?? ServiceTypes.Receive.Response.init(dataReceived: "Error", actionStatus: .Error))
        }
    }
    
   // Net Code
//    internal func broadcast(teamID: Int){
//        guard let connections = DataManager.shared.fetchConnections(teamID: teamID) else {return}
//
//        let message = Message(text: message, senderNick: nickname, destinationRoom: roomName, kind: .public)
//        let encoder = JSONEncoder()
//
//
//        if let data = try? encoder.encode(message), let jsonDocument = String(data: data, encoding: .utf8)
//        {
//            connections.forEach({ $0.webSocket.send(jsonDocument) })
//        }
//    }
    
    
}

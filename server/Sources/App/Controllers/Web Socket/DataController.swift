//
//  DataController.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

internal class DataController{
    
    
    /// Add a Data to Database
    /// - Parameter data: Data to add
    internal func addData(data: ServiceTypes.Dispatch.Request){
        DataManager.shared.appendData(request: .init(data:"" )) { (response) in            
        }
    }
    
    internal func fetchData(sessionID: Request,dataMessage: ServiceTypes.Receive.Request,completion: @escaping (ServiceTypes.Receive.Response) -> ()){
        DataManager.shared.fetchData(sessionRequest: sessionID,dataRequest: dataMessage) { (response) in
            completion(response ?? ServiceTypes.Receive.Response.init(dataReceived: nil, actionStatus: .Error))
        }
    }
    
    
    /// Call Manager to perform action to add user to a certain team
    /// - Parameters:
    ///   - userID: user identification
    ///   - teamID: team identification
    ///   - connection: connection identification
    internal func enteredUser(userID: String,teamID: String,connection: WebSocket){
        DataManager.shared.addUser(userID: userID, teamID: teamID, socket: connection)
    }
    
    
    /// Broadcast certain data to all users in the connection (currently using one)
    /// - Parameter data: Data to send to all users
    internal func broadcast(data: String){
        let connections = DataManager.shared.fetchConnections()
        connections.forEach({ $0.webSocket.send(data)})
    }
    
}

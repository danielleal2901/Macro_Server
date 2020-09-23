//
//  DataController.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

internal class DataController{
    typealias Services = ServiceTypes
    
    /// Add a Data to Database
    /// - Parameter data: Data to add
    internal func addData(sessionRequest: Request, data: Services.Dispatch.Request,completion: @escaping (Services.Dispatch.Response) -> ()){
        DataManager.shared.appendData(sessionRequest: sessionRequest, request: data) { (response) in
            completion(response!)
        }
    }

    ///
    /// - Parameters:
    ///   - sessionID:
    ///   - dataMessage:
    ///   - completion:
    /// - Returns:
    internal func fetchData(sessionID: Request,dataMessage: Services.Receive.Request,completion: @escaping (Services.Receive.Response) -> ()){
        DataManager.shared.fetchData(sessionRequest: sessionID,dataRequest: dataMessage) { (response) in
            completion(response ?? Services.Receive.Response.init(dataReceived: nil, actionStatus: .Error))
        }
    }
    
    internal func updateData(sessionID: Request,dataMessage: Services.Dispatch.Request,completion: @escaping (Services.Dispatch.Response) -> ()){
        DataManager.shared.updateData(sessionRequest: sessionID,dataRequest: dataMessage) { (response) in
            completion(response ?? Services.Dispatch.Response.init(actionStatus: .Error))
        }
    }
    
    
    internal func deleteData(sessionRequest: Request,dataID: UUID()){
        DataManager.shared.deleteData(sessionRequest: sessionID,dataID: dataID) { (response) in
            completion(response ?? Services.Dispatch.Response.init(actionStatus: .Error))
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
        // Do not send to current id sender
        connections.forEach({ $0.webSocket.send(data)})
    }
    
}

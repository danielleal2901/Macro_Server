//
//  DataController.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

internal class WSInteractor{
    typealias Services = ServiceTypes
    
    
    internal func addData(sessionRequest: Request, data: Services.Dispatch.Request,completion: @escaping (Services.Dispatch.Response) -> ()){
        WSDataWorker.shared.appendData(sessionRequest: sessionRequest, request: data) { (response) in
            completion(response)
            switch response.actionStatus{
            case .Completed:
                self.broadcastData(data: data.data,idUser: data.data.respUserID)
            case .Error:
                print()
            default:
                print()
            }
        }
    }
    
    internal func fetchData(sessionID: Request,dataMessage: Services.Receive.Request,completion: @escaping (Services.Receive.Response) -> ()){
        WSDataWorker.shared.fetchData(sessionRequest: sessionID,dataRequest: dataMessage) { (response) in
            completion(response ?? Services.Receive.Response.init(dataReceived: nil, actionStatus: .Error))
            switch response!.actionStatus{
            case .Completed:
                self.broadcastData(data: dataMessage.data,idUser: dataMessage.data.respUserID)
            case .Error:
                print()
            default:
                print()
            }
        }
    }
    
    internal func updateData(sessionID: Request,dataMessage: Services.Dispatch.Request,completion: @escaping (Services.Dispatch.Response) -> ()){
        WSDataWorker.shared.updateData(sessionRequest: sessionID,dataRequest: dataMessage) { (response) in
            completion(response ?? Services.Dispatch.Response.init(actionStatus: .Error))
            switch response!.actionStatus{
            case .Completed:
                self.broadcastData(data: dataMessage.data,idUser: dataMessage.data.respUserID)
            case .Error:
                print()
            default:
                print()
            }
        }
    }
    
    
    internal func deleteData(sessionRequest: Request,package: WSDataPackage,completion: @escaping (Services.Dispatch.Response) -> ()){
        WSDataWorker.shared.deleteData(sessionRequest: sessionRequest, package: package,dataType: package.dataType) { (response) in
            completion(response)
            switch response.actionStatus{
            case .Completed:
                self.broadcastData(data: package,idUser: package.respUserID)
            case .Error:
                print()
            default:
                print()
            }
        }
    }
    
    /// Call Data Worker to perform action to add user to a certain team
    /// - Parameters:
    ///   - userID: user identification
    ///   - teamID: team identification
    ///   - connection: connection identification
    internal func enteredUser(userID: UUID,teamID: UUID,connection: WebSocket){
        WSDataWorker.shared.addUser(userID: userID, teamID: teamID, socket: connection)
    }
    
    
    /// Broadcast certain data to all users in the connection (currently using one)
    /// - Parameter data: Data to send to all users
    internal func broadcastData<T>(data: T,idUser: UUID) where T:Codable {
        let connections = WSDataWorker.shared.fetchConnections()
        // Do not send to current id sender
        let encoded = CoderHelper.shared.encodeDataToString(valueToEncode: data)
        connections.forEach({
//            if $0.userID != idUser{
//                $0.webSocket.send([UInt8(data)])
                $0.webSocket.send(encoded)
//            }
            
        })
    }
    
    
}

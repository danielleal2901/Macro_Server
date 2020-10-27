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
            switch response.actionStatus{
            case .Completed:
                self.broadcastData(data: data.data,idUser: data.data.respUserID, idTeam: data.data.destTeamID)
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
                print()
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
                self.broadcastData(data: dataMessage.data,idUser: dataMessage.data.respUserID, idTeam: dataMessage.data.destTeamID)
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
                self.broadcastData(data: package,idUser: package.respUserID, idTeam: package.destTeamID)
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
    internal func enteredUser(req: Request,userState: WSUserState,connection: WebSocket){
        WSDataWorker.shared.addUser(userState: userState,socket: connection, completion: { user in
            userState.create(on: req.db)             
            self.broadcastData(data: userState, idUser: user.respUserID, idTeam: UUID())
        })
    }
    
    func updateUserId(id: UUID, previousId: UUID){
        
        for i in 0 ..< WSDataWorker.shared.connections.count {
            if (WSDataWorker.shared.connections[i].userState.respUserID == previousId){
                WSDataWorker.shared.connections[i].userState.respUserID = id
            }
        }

    }
    
    internal func changeStage(userState: WSUserState,connection: WebSocket){
        WSDataWorker.shared.changeUserStage(userState: userState, socket: connection, completion: { user in
            let data = try! JSONEncoder().encode(user)
            self.broadcastData(data: data, idUser: user.respUserID, idTeam: user.destTeamID)
        })
    }
    
    
    internal func signOutUser(userID: UUID,connection: WebSocket){
        WSDataWorker.shared.removeUser(userID: userID, socket: connection)
    }
    
    /// Broadcast certain data to all users in the connection (currently using one)
    /// - Parameter data: Data to send to all users
    internal func broadcastData<T>(data: T,idUser: UUID, idTeam: UUID) where T:Codable {
        let connections = WSDataWorker.shared.fetchConnections()
        // Do not send to current id sender
        let encoded = CoderHelper.shared.encodeDataToString(valueToEncode: data)
        connections.forEach({
            if $0.userState.respUserID != idUser  {
                $0.webSocket.send(encoded)
            }
        })
    }
    
    
}

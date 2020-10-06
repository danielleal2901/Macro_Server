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
    internal func enteredUser(userState: WSUserState,connection: WebSocket,req: Request){
        WSDataWorker.shared.addUser(userState: userState,socket: connection, completion: { user in
            let data = try! JSONEncoder().encode(user)
            self.insertUserState(state: user, req: req)
            self.broadcastData(data: data, idUser: user.respUserID)
        })
    }
    
    @discardableResult
    func insertUserState(state: WSUserState,req: Request) -> EventLoopFuture<WSUserState>{
        return User.query(on: req.db).filter("id", .equal, state.respUserID).first().map { (user) -> (WSUserState) in
            state.name = user?.name
            state.photo = user?.name
            state.save(on: req.db)
            return state
        }
    }
    
    func updateUserId(id: UUID, previousId: UUID){
        
        for i in 0 ..< WSDataWorker.shared.connections.count {
            if (WSDataWorker.shared.connections[i].userState.respUserID == previousId){
                WSDataWorker.shared.connections[i].userState.respUserID = id
            }
        }
        
    }
    
    internal func changeStage(userState: WSUserState,connection: WebSocket,req: Request) {
        WSDataWorker.shared.changeUserStage(userState: userState, socket: connection, completion: { user in
            do{
                try updateUserState(req: req, newState: userState)
            } catch(let error){print(error.localizedDescription)}
        })
    }
    
    @discardableResult
    internal func updateUserState(req: Request,newState: WSUserState) throws -> EventLoopFuture<WSUserState>{
        guard let uuid = newState.id else {throw Abort(.notFound)}
        
        return WSUserState.find(uuid, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (state) in                
                state.respUserID = newState.respUserID
                state.destTeamID = newState.destTeamID
                state.stageID = newState.stageID
                let codedState = CoderHelper.shared.encodeGenericToData(valueToEncode: state)
                self.broadcastData(data: codedState, idUser: state.respUserID)
                return state.update(on: req.db).transform(to: state)
        }
    }
    
    
    internal func signOutUser(userID: UUID,connection: WebSocket,req: Request) throws -> EventLoopFuture<Void>{
        WSDataWorker.shared.removeUser(userID: userID, socket: connection)
        return WSUserState.query(on: req.db).all().map {  value in
            value.forEach { (user) in
                if user.respUserID == userID{
                    WSUserState.find(user.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
                        $0.delete(on: req.db)
                    }
                }
            }
        }
        
    }
    
    /// Broadcast certain data to all users in the connection (currently using one)
    /// - Parameter data: Data to send to all users
    internal func broadcastData<T>(data: T,idUser: UUID) where T:Codable {
        let connections = WSDataWorker.shared.fetchConnections()
        // Do not send to current id sender
        let encoded = CoderHelper.shared.encodeDataToString(valueToEncode: data)
        connections.forEach({
            if $0.userState.respUserID != idUser{
                $0.webSocket.send(encoded)
            }
        })
    }
    
    
}

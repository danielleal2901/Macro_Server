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
    
    
    internal func addData(sessionRequest: Request, dataMessage: Services.Dispatch.Request,completion: @escaping (Services.Dispatch.Response) -> ()){
        WSDataWorker.shared.appendData(sessionRequest: sessionRequest, request: dataMessage) { (response) in
            switch response.actionStatus{
            case .Completed:
                self.broadcastData(data: dataMessage.data,idUser: dataMessage.data.respUserID, idTeam: dataMessage.data.destTeamID)
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
    
    
    internal func deleteData(sessionRequest: Request,dataMessage: WSDataPackage,completion: @escaping (Services.Dispatch.Response) -> ()){
        WSDataWorker.shared.deleteData(sessionRequest: sessionRequest, package: dataMessage,dataType: dataMessage.dataType) { (response) in
            completion(response)
            switch response.actionStatus{
            case .Completed:
                self.broadcastData(data: dataMessage,idUser: dataMessage.respUserID, idTeam: dataMessage.destTeamID)
            case .Error:
                print()
            default:
                print()
            }
        }
    }
    
    
    //Cadastrando nova conexao ao array de conexoes do ws
    internal func enteredUser(user: User,connection: WebSocket,req: Request, currentWsId: UUID){
        WSDataWorker.shared.addUser(user: user,socket: connection, currentWsId: currentWsId, completion: { result in
            if (result){
                self.throwLoginResult(result: .loginSucceded, ws: connection, userData: user)
            }else {
                self.throwLoginResult(result: .userAlreadyLogged, ws: connection, userData: user)
            }
        })
    }
    
    //Adicionar usuario ao time
    func addUser(ws:WebSocket, req: Request,dataMessage: WSDataPackage) -> EventLoopFuture<HTTPStatus> {
        
        return Team.find(dataMessage.destTeamID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (team) in
                return User.find(dataMessage.respUserID,on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMapThrowing { (userOptional) -> EventLoopFuture<Void> in
                        
                        let user = try User(id: userOptional.id, name: userOptional.name, email: userOptional.email, password: userOptional.password, isAdmin: userOptional.isAdmin, image: userOptional.image, teamID: userOptional.$team.id)
                        
                        return try self.fetchTeamResponse(req: req, user: user, isAdding: true)
                                .flatMap { (teamResult) -> EventLoopFuture<Void> in
                                    team.activeUsers.append(userOptional.id!)
                                    self.sendTeamPackage(newTeam: teamResult, user: user)
                                    return team.update(on: req.db)
                        }
                }
        }.transform(to: .ok)
    }
    
    //WS Close
    func removeUserConnection(currentWsId: UUID, req: Request) {
        
        guard let connection = WSDataWorker.shared.fetchConnections().first(where: {$0.webSocketId == currentWsId}) else {return}
        let user = connection.user
        
        WSDataWorker.shared.removeUser(userID: user.id!, socket: connection.webSocket)
        
        _ = Team.find(user.$team.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { (team) in
                
                return try self.fetchTeamResponse(req: req, user: user, isAdding: false)
                    .map { (teamResult) -> EventLoopFuture<Void> in
                        team.activeUsers.removeAll(where: {$0 == user.id})
                        self.sendTeamPackage(newTeam: teamResult, user: user)
                        return team.update(on: req.db)
                }
        }
    }
    
    func fetchTeamResponse(req: Request, user: User, isAdding: Bool) throws -> EventLoopFuture<TeamResponse>{
        req.parameters.set(TeamParameters.teamId.rawValue, to: user.$team.id.uuidString)
        
        return try TeamController().getTeamById(req: req)
            .map { (teamResponse)  in
                var teamMuttable = teamResponse
                if (!isAdding){
                    teamMuttable.activeUsers.removeAll(where: {$0.id == user.id!})
                }else {
                    teamMuttable.activeUsers.append(UserResponse(id: user.id!, name: user.name, email: user.email, password: user.password, isAdmin: user.isAdmin, image: user.image, teamId: user.$team.id))
                }
                return teamMuttable
        }
    }
    
    func sendTeamPackage(newTeam: TeamResponse, user: User) {
        guard let data = CoderHelper.shared.encodeGenericToData(valueToEncode: newTeam) else {return}
        let package = WSDataPackage(packageID: UUID(), content: data, dataType: .teams, destTeamID: newTeam.id!, respUserID: user.id!, operation: .update, containerID: UUID())
        self.broadcastData(data: package, idUser: user.id!, idTeam: user.$team.id)
    }
    
    
    //    @discardableResult
    //    func insertUserState(state: WSUserState,req: Request) -> EventLoopFuture<WSUserState>{
    //        return User.find(state.respUserID, on: req.db)
    //            .unwrap(or: Abort(.notFound))
    //            .flatMap { (optionalUserState) -> EventLoopFuture<WSUserState> in
    //                state.name = optionalUserState.name
    //                state.photo = optionalUserState.name
    //                print(state)
    //                self.broadcastData(data: state, idUser: state.respUserID, idTeam: state.destTeamID,idContainer: state.containerID)
    //                return state.save(on: req.db).transform(to: state)
    //
    //        }
    //    }
    //
    //    func updateUserId(id: UUID, previousId: UUID){
    //        for i in 0 ..< WSDataWorker.shared.connections.count {
    //            if (WSDataWorker.shared.connections[i].userState.respUserID == previousId){
    //                WSDataWorker.shared.connections[i].userState.respUserID = id
    //            }
    //        }
    //
    //    }
    //
    //    internal func changeStageState(userState: WSUserState,connection: WebSocket,req: Request) {
    //        WSDataWorker.shared.changeUserStage(userState: userState, socket: connection, completion: { user in
    //            do{
    //                try updateUserState(req: req, newState: userState)
    //            } catch(let error){print(error.localizedDescription)}
    //
    //        })
    //    }
    //
    //    @discardableResult
    //    internal func updateUserState(req: Request,newState: WSUserState) throws -> EventLoopFuture<WSUserState>{
    //        guard let uuid = newState.id else {throw Abort(.notFound)}
    //
    //        return WSUserState.find(uuid, on: req.db)
    //            .unwrap(or: Abort(.notFound))
    //            .flatMap { (state) in
    //                state.containerID = newState.containerID
    //                self.broadcastData(data: state, idUser: state.respUserID, idTeam: state.destTeamID,idContainer: state.containerID)
    //                return state.update(on: req.db).transform(to: state)
    //        }
    //    }
    //    internal func signOutUser(userID: UUID,connection: WebSocket,req: Request) throws -> EventLoopFuture<Void>{
    //        WSDataWorker.shared.removeUser(userID: userID, socket: connection)
    //        return WSUserState.query(on: req.db).all().map {  value in
    //            value.forEach { (user) in
    //                if user.respUserID == userID{
    //                    WSUserState.find(user.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
    //                        $0.delete(on: req.db)
    //                    }
    //                }
    //            }
    //        }
    //
    //    }
    
    /// Broadcast certain data to all users in the connection (currently using one)
    /// - Parameter data: Data to send to all users
    internal func broadcastData(data: WSDataPackage,idUser: UUID, idTeam: UUID) {
        let connections = WSDataWorker.shared.fetchConnections()
        // Do not send to current id sender
        let encoded = CoderHelper.shared.encodeDataToString(valueToEncode: data)
        connections.forEach({
            if $0.user.id != idUser && $0.user.$team.id == idTeam{
                $0.webSocket.send(encoded)
            }
        })
    }
    
    internal func throwLoginResult(result: WSLoginOperations, ws: WebSocket, userData: User)  {
        // Do not send to current id sender
        guard let encoded = CoderHelper.shared.encodeGenericToData(valueToEncode: result) else {return}
        let package = WSDataPackage(packageID: UUID(), content: encoded, dataType: .loginOperations, destTeamID: userData.$team.id, respUserID: userData.id!, operation: .login, containerID: UUID())
        let encodedPackage = CoderHelper.shared.encodeDataToString(valueToEncode: package)
        ws.send(encodedPackage)
    }
    
    
}


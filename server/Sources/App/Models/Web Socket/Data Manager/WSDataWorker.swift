//
//  WSDataWorker.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

internal class WSDataWorker{
    
    
    // MARK - Variables
    /// Singleton
    internal static let shared = WSDataWorker()
    internal let dataManager = DataManager()
    /// Connection for future use
    var connections: [TeamConnection] // To Change
    
    // MARK - Initializer
    private init(){
        self.connections = [TeamConnection]()
    }
    
    // Change Request to Request type of Vip Cycle
    
    /// Append Some Data on the Storage included on WSDataWorker
    /// - Parameters:
    ///   - request: Request action with Data that needs to be included in Database
    ///   - completion: Response of Receive action, including the result of action Status
    internal func appendData(sessionRequest: Request, request: ServiceTypes.Dispatch.Request,completion: @escaping (ServiceTypes.Dispatch.Response) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        switch request.data.dataType{
        case .container:

            do{
                let containerInput = try CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: StagesContainer.Inoutput.self)
                let akaresponse = try dataManager.createContainer(containerInput: containerInput, req: sessionRequest)                
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case .stage:
            do{
                let stageInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Stage.Inoutput.self)
                let akaresponse = try dataManager.createStage(req: sessionRequest, stage: stageInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case .overview:
            do{
                let overviewInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Overview.Inoutput.self)
                
                let akaresponse = try dataManager.createOverview(req: sessionRequest, overviewInput: overviewInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case .status:
            do{
                let statusInput = try CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Status.Inoutput.self)
                
                let akaresponse = try dataManager.createStatus(req: sessionRequest, statusInoutput: statusInput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case .document :
            do{
                let documentInput = try CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Document.Inoutput.self)
                
                let akaresponse = try dataManager.createDocument(req: sessionRequest, documentInoutput: documentInput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        default:
            print("Not working")
            response.actionStatus = .Error
            completion(response)
        }
    }
    
    
    
    // MARK - Functions
    
    /// Fetch Data of current Database Storage
    /// - Parameters:
    ///   - request: Request of Receive action, having id for search in database
    ///   - completion: Response of Receive action, having the data found on the database, including the result of action Status
    internal func fetchData(sessionRequest: Request , dataRequest: ServiceTypes.Receive.Request,completion: @escaping (ServiceTypes.Receive.Response?) -> ()){

        
    }
    
    
    internal func  updateData(sessionRequest: Request , dataRequest: ServiceTypes.Dispatch.Request,completion: @escaping (ServiceTypes.Dispatch.Response?) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        switch dataRequest.data.dataType{

        case .container:
            do{
                let containerInput = try CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: StagesContainer.Inoutput.self)
                let akaresponse = try dataManager.updateContainer(req: sessionRequest, newContainer: containerInput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case .stage:
            do{
                let stageInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Stage.Inoutput.self)
                
                let akaresponse = try dataManager.updateStage(req: sessionRequest, newStage: stageInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
            
        case .overview:
            
            do{
                let overviewInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Overview.Inoutput.self)
                
                let akaresponse = try dataManager.updateOverview(req: sessionRequest, newOverview: overviewInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case .status:
            do{
                let statusInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Status.Inoutput.self)
                
                let akaresponse = try dataManager.updateStatus(req: sessionRequest, newStatus: statusInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
        
        case .document:
            do{
                let documentInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Document.Inoutput.self)
                
                let akaresponse = try dataManager.updateDocument(req: sessionRequest, newDocument: documentInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
        case .teams:
            do{
                let team = try CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: TeamRequest.self)
                
                let akaresponse = try dataManager.updateTeamById(req: sessionRequest, newTeam: team)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
        default:
            print("Not working")
            response.actionStatus = .Error
            completion(response)
        }
        
            
        
    }
    
    internal func deleteData(sessionRequest: Request,package: WSDataPackage,dataType: DataTypes,completion: @escaping (ServiceTypes.Dispatch.Response) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        switch dataType{

        case .container:
            
            do{
                let containerInput = try CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: StagesContainer.Inoutput.self)
                let akaresponse = try dataManager.deleteContainer(req: sessionRequest, container: containerInput)
                
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }
            
        case .stage:
            
            
            do{
                let stageInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Stage.Inoutput.self)
                
                let akaresponse = try dataManager.deleteStage(req: sessionRequest, stage: stageInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }
        case .overview:
            do{
                let overviewInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Overview.Inoutput.self)
                
                let akaresponse = try dataManager.deleteOverview(req: sessionRequest, overview: overviewInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }
        case .status:
            do{
                let statusInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Status.Inoutput.self)
                
                let akaresponse = try dataManager.deleteStatus(req: sessionRequest, status: statusInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }
        case .document:
            do{
                let documentInoutput = try CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Document.Inoutput.self)
                
                let akaresponse = try dataManager.deleteDocument(req: sessionRequest, document: documentInoutput)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }
            
        case .files:
            do{
                let fileId = try CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: UUID.self)
                
                let akaresponse = try dataManager.deleteFile(req: sessionRequest, fileItemId: fileId)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }
        case .users:
            break
        case .teams:
            break

        }
        
    }
    
    
    
    /// Add a user to a group (currently using one instance)
    /// - Parameters:
    ///   - userID: user identification
    ///   - teamID: team identification
    ///   - socket: websocket
    func addUser(userState: WSUserState,socket: WebSocket,completion: (WSUserState) -> ()){
        let connection = TeamConnection(userState: userState, webSocket: socket)
        self.connections.append(connection)
        completion(connection.userState)
    }
    
    func changeUserStage(userState: WSUserState,socket: WebSocket,completion: (WSUserState) -> ()){
        for user in connections{
            if user.userState.respUserID == userState.respUserID{
                user.userState.containerID = userState.containerID
                completion(user.userState)
            }
        }
    }
    
    func removeUser(userID: UUID,socket: WebSocket){
        connections = self.connections.filter {
            return $0.userState.respUserID != userID
        }
    }
    
    /// Fetch all connections active (current using one instance)
    /// - Returns: intended connection
    func fetchConnections() -> [TeamConnection]{
        return self.connections
    }
    
    // To implement
    
    // Login Management
    // User
    internal func createUser(){}
    internal func fetchUser(){}
    internal func updateUser(){}
    internal func deleteUser(){}
    
    // Login Management
    // Team
    internal func createTeam(){}
    internal func fetchTeam(){}
    internal func updateTeam(){}
    internal func deleteTeam(){}
    
    
}

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
        guard let dataType = request.data.dataType as? DataTypes else {return}
        
        switch dataType{
        case .terrain:
            //TerrainController().insertTerrainSQL(terrain: dataDecoded!, req: sessionRequest)
            let terrainInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Terrain.Inoutput.self)
            do{
                let akaresponse = try dataManager.createTerrain(terrainInput: terrainInput!, req: sessionRequest)
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
            let stageInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Stage.Inoutput.self)
                
            do{
                let akaresponse = try dataManager.createStage(req: sessionRequest, stage: stageInoutput!)
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
            let overviewInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Overview.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.createOverview(req: sessionRequest, overviewInput: overviewInoutput!)
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
            let statusInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Status.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.createStatus(req: sessionRequest, statusInoutput: statusInput!)
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
            let documentInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Document.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.createDocument(req: sessionRequest, documentInoutput: documentInput!)
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
//        var response:  ServiceTypes.Receive.Response = .init(dataReceived: .none, actionStatus: .Requesting)
        
        switch dataRequest.data.dataType{
        case .terrain:
            print()
        case .stage:
            print()
        default:
            print()
            
        }
    }
    
    
    internal func updateData(sessionRequest: Request , dataRequest: ServiceTypes.Dispatch.Request,completion: @escaping (ServiceTypes.Dispatch.Response?) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        switch dataRequest.data.dataType{
        case .terrain:
            let terrainInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Terrain.Inoutput.self)
            do{
                let akaresponse = try dataManager.updateTerrain(req: sessionRequest,newTerrain: terrainInput!)
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
            let stageInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Stage.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.updateStage(req: sessionRequest, newStage: stageInoutput!)
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
            let overviewInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Overview.Inoutput.self)
            do{
                let akaresponse = try dataManager.updateOverview(req: sessionRequest, newOverview: overviewInoutput!)
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
            let statusInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Status.Inoutput.self)

            do{
                let akaresponse = try dataManager.updateStatus(req: sessionRequest, newStatus: statusInoutput!)
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
            let documentInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Document.Inoutput.self)
            do{
                let akaresponse = try dataManager.updateDocument(req: sessionRequest, newDocument: documentInoutput!)
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
        case .terrain:
            let terrainInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Terrain.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.deleteTerrain(req: sessionRequest, terrain: terrainInoutput!)
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
            let stageInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Stage.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.deleteStage(req: sessionRequest, stage: stageInoutput!)
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
            let overviewInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Overview.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.deleteOverview(req: sessionRequest, overview: overviewInoutput!)
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
            let statusInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Status.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.deleteStatus(req: sessionRequest, status: statusInoutput!)
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
            let documentInoutput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Document.Inoutput.self)
            
            do{
                let akaresponse = try dataManager.deleteDocument(req: sessionRequest, document: documentInoutput!)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }
            
        case .file:
            guard let fileItemId = try? CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: UUID.self) else {
                response.actionStatus = .Error
                completion(response)
                return
            }
            
            do{
                let akaresponse = try dataManager.deleteFile(req: sessionRequest, fileItemId: fileItemId)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
                
            }

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
                user.userState.stageID = userState.stageID
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

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
    /// Connection for future use
    internal private(set) var connections: [TeamConnection] // To Change
    
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
        
        //let dataDecoded = CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: TerrainModel.self)
        //guard let decoded = dataDecoded else {return}
        
        switch request.data.dataType{
        case "terrain":            
            //TerrainController().insertTerrainSQL(terrain: dataDecoded!, req: sessionRequest)
            response.actionStatus = .Completed
            completion(response)
        case "stage":
            let stageInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Stage.Input.self)
            guard let id = UUID(uuidString: stageInput!.terrain) else {return}
            let stage = Stage(type: stageInput!.stageType, terrainID: id)
            
            let akaresponse = stage.save(on: sessionRequest.db)
            stage.update(on: sessionRequest.db)
            
            akaresponse.whenSuccess { _ in
                response.actionStatus = .Completed
                completion(response)
            }
            
            akaresponse.whenFailure { _ in
                response.actionStatus = .Error
                completion(response)
            }
            
        case "overview":
            let overviewInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Overview.Input.self)
            guard let id = UUID(uuidString: overviewInput!.stageId) else {return}
            let overview = Overview(stageID: id, sections: (overviewInput?.sections)!)
            
            let akaresponse = overview.save(on: sessionRequest.db)
            
            akaresponse.whenSuccess { _ in
                response.actionStatus = .Completed
                completion(response)
            }
            
            akaresponse.whenFailure { _ in
                response.actionStatus = .Error
                completion(response)
            }
            
        case "status":
            let overviewInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Overview.Input.self)
            guard let id = UUID(uuidString: overviewInput!.stageId) else {return}
            let overview = Overview(stageID: id, sections: (overviewInput?.sections)!)
            
            let akaresponse = overview.save(on: sessionRequest.db)
            
            akaresponse.whenSuccess { _ in
                response.actionStatus = .Completed
                completion(response)
            }
            
            akaresponse.whenFailure { _ in
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
        var response:  ServiceTypes.Receive.Response = .init(dataReceived: .none, actionStatus: .Requesting)
        
        switch dataRequest.data.dataType{
        case "terrain":
            let eventData = try! TerrainController().fetchAllTerrains(req: sessionRequest)
            eventData.whenSuccess { (terrains) in
                let encodedValue = try? JSONEncoder().encode(terrains)
                response.dataReceived = encodedValue!
                response.actionStatus = .Completed
                completion(response)
            }
        case "stage":
            print()
        default:
            print()
            
        }
    }
    
    
    internal func updateData(sessionRequest: Request , dataRequest: ServiceTypes.Dispatch.Request,completion: @escaping (ServiceTypes.Dispatch.Response?) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        let dataDecoded = CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: TerrainModel.self)
        
        switch dataRequest.data.dataType{
        case "terrain":
            TerrainController().updateTerrainSQL(terrain: dataDecoded!, req: sessionRequest)
            response.actionStatus = .Completed
            completion(response)
        case "stage":
            print()
        default:
            print("Not working")
            response.actionStatus = .Error
            completion(response)
        }
        
    }
    
    internal func deleteData(sessionRequest: Request,dataID: UUID,dataType: String,completion: @escaping (ServiceTypes.Dispatch.Response) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        switch dataType{
        case "terrain":
            TerrainController().deleteTerrainSQL(id: dataID, req: sessionRequest)
            response.actionStatus = .Completed
            completion(response)
        default:
            print("Not working")
            response.actionStatus = .Error
            completion(response)
        }
        
    }
    
    
    
    /// Add a user to a group (currently using one instance)
    /// - Parameters:
    ///   - userID: user identification
    ///   - teamID: team identification
    ///   - socket: websocket
    func addUser(userID: UUID,teamID: UUID,socket: WebSocket){
        let connection = TeamConnection(userID: userID, teamID: teamID, webSocket: socket)
        self.connections.append(connection)
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

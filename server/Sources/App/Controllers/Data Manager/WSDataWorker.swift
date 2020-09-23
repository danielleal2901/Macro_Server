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
    internal func appendData(sessionRequest: Request, request: ServiceTypes.Dispatch.Request,completion: (ServiceTypes.Dispatch.Response?) -> ()){
         var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        let dataDecoded = CodableAlias().decodeDataSingle(valueToDecode: request.data.data, intendedType: TerrainModel.self)
        
        switch request.data.dataType{
        case "terrain":
            TerrainController().insertTerrainSQL(terrain: dataDecoded!, req: sessionRequest)
            response.actionStatus = .Completed
            completion(response)
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
        // Change Event Data for DataTypes conforming to Enum
        //var eventData: EventLoopFuture<[DataTypes]>
        switch dataRequest.data.dataType{
        case "terrain":
            let eventData = try! TerrainController().fetchAllTerrains(req: sessionRequest)
            eventData.whenSuccess { (terrains) in
                let encodedValue = try? JSONEncoder().encode(terrains)
                response.dataReceived = encodedValue!
                response.actionStatus = .Completed
                completion(response)
            }
        case "georeferecing":
            // Change Terrain Controller
            let eventData = try! TerrainController().fetchAllTerrains(req: sessionRequest)
            eventData.whenSuccess { (terrains) in
                let encodedValue = try? JSONEncoder().encode(terrains)
                response.dataReceived? = encodedValue!
                response.actionStatus = .Completed
                completion(response)
            }
        default:
            print()
        }
    }
    
    internal func updateData(sessionRequest: Request , dataRequest: ServiceTypes.Dispatch.Request,completion: @escaping (ServiceTypes.Dispatch.Response?) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        let dataDecoded = CodableAlias().decodeDataSingle(valueToDecode: dataRequest.data.data, intendedType: TerrainModel.self)
        
        switch dataRequest.data.dataType{
        case "terrain":
            TerrainController().updateTerrainSQL(terrain: dataDecoded!, req: sessionRequest)
            response.actionStatus = .Completed
            completion(response)
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
    func addUser(userID: String,teamID: String,socket: WebSocket){
        let connection = TeamConnection(name: userID, teamName: teamID, webSocket: socket)
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

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
        
        switch request.data.dataType{
        case "terrain":            
            //TerrainController().insertTerrainSQL(terrain: dataDecoded!, req: sessionRequest)
            let terrainInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Terrain.Inoutput.self)
            do{
                let akaresponse = try createTerrain(terrainInput: terrainInput!, req: sessionRequest)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case "stage":
            let stageInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Stage.Input.self)
            guard let id = UUID(uuidString: stageInput!.terrain) else {return}
            let stage = Stage(type: stageInput!.stageType, terrainID: id)
            
            let akaresponse = stage.save(on: sessionRequest.db)
            
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
            let overview = Overview(stageId: id, sections: overviewInput!.sections)
            
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
            let statusInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: request.data.content, intendedType: Status.Input.self)
            guard let id = UUID(uuidString: statusInput!.stageId) else {return}
            let status = Status(stageId: id, sections: statusInput!.sections)
            
            
            let akaresponse = status.save(on: sessionRequest.db)
            
            akaresponse.whenSuccess { _ in
                response.actionStatus = .Completed
                completion(response)
            }
            
            akaresponse.whenFailure { _ in
                response.actionStatus = .Error
                completion(response)
            }
        case "":
            print()
            
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
            print()
            
        case "stage":
            print()
        default:
            print()
            
        }
    }
    
    
    internal func updateData(sessionRequest: Request , dataRequest: ServiceTypes.Dispatch.Request,completion: @escaping (ServiceTypes.Dispatch.Response?) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        switch dataRequest.data.dataType{
        case "terrain":
            //TerrainController().insertTerrainSQL(terrain: dataDecoded!, req: sessionRequest)
            let terrainInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Terrain.Inoutput.self)
            guard let id = terrainInput?.id else {return}
            do{
                let akaresponse = try updateTerrain(req: sessionRequest,newTerrain: terrainInput!)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch(let error) {
                print(error.localizedDescription)
                response.actionStatus = .Error
                completion(response)
            }
            
        case "stage":
            let stageInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Stage.Input.self)
            guard let id = UUID(uuidString: stageInput!.terrain) else {return}
            let stage = Stage(type: stageInput!.stageType, terrainID: id)
            
            let akaresponse = stage.save(on: sessionRequest.db)
            
            akaresponse.whenSuccess { _ in
                response.actionStatus = .Completed
                completion(response)
            }
            
            akaresponse.whenFailure { _ in
                response.actionStatus = .Error
                completion(response)
            }
            
        case "overview":
            let overviewInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Overview.Input.self)
            guard let id = UUID(uuidString: overviewInput!.stageId) else {return}
            let overview = Overview(stageId: id, sections: overviewInput!.sections)
            
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
            let statusInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataRequest.data.content, intendedType: Status.Input.self)
            guard let id = UUID(uuidString: statusInput!.stageId) else {return}
            let status = Status(stageId: id, sections: statusInput!.sections)
            
            
            let akaresponse = status.save(on: sessionRequest.db)
            
            akaresponse.whenSuccess { _ in
                response.actionStatus = .Completed
                completion(response)
            }
            
            akaresponse.whenFailure { _ in
                response.actionStatus = .Error
                completion(response)
            }
        case "":
            print()
            
        default:
            print("Not working")
            response.actionStatus = .Error
            completion(response)
        }
        
    }
    
    internal func deleteData(sessionRequest: Request,package: WSDataPackage,dataID: UUID,dataType: String,completion: @escaping (ServiceTypes.Dispatch.Response) -> ()){
        var response:  ServiceTypes.Dispatch.Response = .init(actionStatus: .Requesting)
        
        switch dataType{
        case "terrain":
            let terrainInput = try? CoderHelper.shared.decodeDataSingle(valueToDecode: package.content, intendedType: Terrain.Inoutput.self)
            
            do{
                let akaresponse = try deleteTerrain(req: sessionRequest, newTerrain: terrainInput!)
                akaresponse.whenSuccess { _ in
                    response.actionStatus = .Completed
                    completion(response)
                }
            } catch (let error){
                response.actionStatus = .Error
                completion(response)
                
            }
            
            
            response.actionStatus = .Completed
            completion(response)
        default:
            print("Not working")
            response.actionStatus = .Error
            completion(response)
        }
        
    }
    
    internal func createTerrain(terrainInput: Terrain.Inoutput,req: Request) throws -> EventLoopFuture<Terrain>{
        let terrain = Terrain(name: terrainInput.name, stages: terrainInput.stages.map{$0.rawValue})
        
        let stages = terrainInput.stages.map{
            Stage(type: $0.self, terrainID: terrain.id!)
        }
        
        return terrain.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informacoes Responsavel", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, sections: [StatusSection(name: "Tarefas Principais", items: [StatusItem(key: "Cooletar dados do shapefile", done: true)])]).create(on: req.db)
                    }
                }
            }
        }.transform(to: terrain)
    }
    
    internal func updateTerrain(req: Request,newTerrain: Terrain.Inoutput) throws -> EventLoopFuture<Terrain>{
        guard let uuid = UUID(uuidString: newTerrain.id!) else {throw Abort(.notFound)}
        
        return Terrain.find(uuid, on: req.db).flatMap { (terrain) in
            terrain?.name = newTerrain.name
            return terrain!.update(on: req.db).transform(to: terrain!)
        }
        
        
        
    }
    
    // Change newTerrain ->>> ID
    internal func deleteTerrain(req: Request,newTerrain: Terrain.Inoutput) throws -> EventLoopFuture<HTTPStatus>{
        guard let uuid = UUID(uuidString: newTerrain.id!) else {throw Abort(.notFound)}
        
        return Terrain.find(uuid, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
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

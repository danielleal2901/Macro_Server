//
//  DataManager.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

internal class DataManager{
    
    
    // MARK - Variables
    /// Singleton
    internal static let shared = DataManager()
    /// Datas stored in the database
    /// Change to a "ViewModel"
    internal private(set) var datas: [String]
    /// Connection for future use
    internal private(set) var connection: [String] // To Change
    
    // MARK - Initializer
    private init(){
        self.datas = [String]()
        self.connection = [String]()
    }
    
    
    // MARK - Functions
    
    /// Fetch Data of current Database Storage
    /// - Parameters:
    ///   - request: Request of Receive action, having id for search in database
    ///   - completion: Response of Receive action, having the data found on the database, including the result of action Status
    internal func fetchData(request: ServiceTypes.Receive.Request,completion: (ServiceTypes.Receive.Response?) -> ()){
        var response:  ServiceTypes.Receive.Response = .init(dataReceived: .none, actionStatus: .Requesting)
    
        if let data = self.datas.filter({
            $0 == request.id
        }).first {
            response.dataReceived = data
            response.actionStatus = .Completed
            
        } else{
            response.dataReceived = .none
            response.actionStatus = .Error
        }
        completion(response)
    }
    
    // Change Request to Request type of Vip Cycle
    
    /// Append Some Data on the Storage included on Data Manager
    /// - Parameters:
    ///   - request: Request action with Data that needs to be included in Database
    ///   - completion: Response of Receive action, including the result of action Status
    internal func appendData(request: ServiceTypes.Dispatch.Request,completion: (ServiceTypes.Receive.Response?) -> ()){
        var response:  ServiceTypes.Receive.Response = .init(dataReceived: .none, actionStatus: .Requesting)
        let previousCount = datas.count
                        
        self.datas.append(request.data)
        
        // May be Useless, to Check
        if  self.datas.count > previousCount {
            response.actionStatus = .Completed
        } else{
            response.actionStatus = .Error
        }
        
        completion(response)
    }
    
    // General Management
    // To implement
    
    // WebSocket
    // Data
    internal func createData(){}
    internal func fetchData(){}
    internal func updateData(){}
    internal func deleteData(){}
    
    
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

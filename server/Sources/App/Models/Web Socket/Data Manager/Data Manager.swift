//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Vapor
import Foundation

struct SpecifiedData{
    var id: Int
}

internal class DataManager{
    
    internal static let shared = DataManager()
    
    // Change to DataType
    internal private(set) var datas: [SpecifiedData]
    internal private(set) var connection: [String] // To Change
    
    private init(){
        self.datas = [SpecifiedData]()
        self.connection = [String]()
    }
    
    internal func fetchData(request: ServiceTypes.Receive.Request,completion: (ServiceTypes.Receive.Response?) -> ()){
        var response:  ServiceTypes.Receive.Response = .init(dataReceived: .none, actionStatus: .Requesting)
    
        if let data = self.datas.filter({
            $0.id == request.id
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
    internal func appendData(request: SpecifiedData,completion: (ServiceTypes.Receive.Response?) -> ()){
        var response:  ServiceTypes.Receive.Response = .init(dataReceived: .none, actionStatus: .Requesting)
        let previousCount = datas.count
        
                
        self.datas.append(request)
        
        if  self.datas.count > previousCount {
            response.actionStatus = .Completed
        } else{
            response.actionStatus = .Error
        }
        
        completion(response)
    }
    
}

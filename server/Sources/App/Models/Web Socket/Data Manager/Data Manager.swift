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
    
    internal func fetch(request: ServiceTypes.Receive.Request,completion: (ServiceTypes.Receive.Response?) -> ()){
        var response:  ServiceTypes.Receive.Response?
    
        if let data = self.datas.filter({
            $0.id == request.id
        }).first {
            response = .init(dataReceived: .some(data), actionStatus: .Sended)            
        } else{
            response = .init(dataReceived: .none, actionStatus: .Error)
        }
        
        completion(response)
    }
    
}

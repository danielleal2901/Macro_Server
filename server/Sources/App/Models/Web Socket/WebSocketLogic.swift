//
//  WebSocketLogic.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation

typealias WebSocketLogic = CommunicationLogic & ConnectionLogic

protocol CommunicationLogic{
    typealias SendType = ServiceTypes.Dispatch.Request
    func send<SendType>(data: SendType) -> ServiceTypes.Dispatch.Response?
    func receive<Destination>(destination: Destination?) -> ServiceTypes.Receive.Response?
}

protocol ConnectionLogic{
    func ping()
    func connect(url: URL) -> ServiceTypes.Connection?
    func suspend(activeSession: String) -> ServiceTypes.Connection?
    func disconnect(activeSession: String) -> ServiceTypes.Connection?
}

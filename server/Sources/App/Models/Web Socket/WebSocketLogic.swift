//
//  WebSocketLogic.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation

protocol WebSocketLogic{
    typealias SendType = ServiceTypes.Dispatch.Request
    func ping()
    func connect() -> ServiceTypes.Connection?
    func send<SendType>(data: SendType) -> ServiceTypes.Dispatch.Response?
    func receive<Destination>(destination: Destination?) -> ServiceTypes.Receive.Response?
}

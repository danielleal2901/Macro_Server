//
//  WebSocketLogic.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/09/20.
//

import Foundation

protocol WebSocketLogic{
    func connect()
    func ping()
    func send()
    func receive()
}

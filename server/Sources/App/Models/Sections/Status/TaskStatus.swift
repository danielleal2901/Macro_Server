//
//  TaskStatus.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 29/10/20.
//

import Foundation

enum TaskStatus: String, Codable{
    case todo = "Não Começou"
    case progress = "Em Progresso"
    case done = "Concluída"
}


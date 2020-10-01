//
//  WSConnnectionPackage.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 01/10/20.
//

import Foundation

internal struct WSConnectionPackage: Codable{
    
    // MARK - Variables
    internal private(set) var packageID: UUID
    internal private(set) var newUserState: WSUserState

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        packageID = try values.decode(UUID.self,forKey: .packageID)
        newUserState = try values.decode(WSUserState.self,forKey: .newUserState)
    }
    
}


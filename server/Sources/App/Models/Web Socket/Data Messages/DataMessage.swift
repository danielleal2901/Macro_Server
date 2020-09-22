//
//  DataMessage.swift
//
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Foundation

internal struct DataMessage: Codable{
    
    // MARK - Variables
    
    internal private(set) var data: Data
    internal private(set) var dataID: String
    internal private(set) var destTeamID: Int
    internal private(set) var respUserID: Int
    
    // In doubt if using this type or another encoder
    private enum CodingKeys: String, CodingKey{
        case data
        case dataID
        case destTeamID = "destination"
        case respUserID = "user"
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode(Data.self,forKey:  .data)
        dataID = try values.decode(String.self,forKey: .dataID)
        destTeamID = try values.decode(Int.self,forKey: .destTeamID)
        respUserID = try values.decode(Int.self,forKey: .respUserID)
    }
    
}

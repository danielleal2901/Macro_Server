//
//  DataMessage.swift
//
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Foundation

internal struct DataMessage: Codable{
    
    // MARK - Variables
    internal private(set) var data: SpecifiedData
    internal private(set) var destTeamID: Int
    internal private(set) var respUser: Int
    
    // In doubt if using this type or another encoder
    private enum CodingKeys: String, CodingKey{
        case data
        case destTeamID = "destination"
        case respUser = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode(SpecifiedData.self,forKey: .data)
        destTeamID = try values.decode(Int.self,forKey: .data)
        respUser = try values.decode(Int.self,forKey: .data)
    }
    
}

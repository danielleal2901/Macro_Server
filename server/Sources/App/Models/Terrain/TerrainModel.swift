//
//  TerrainModel.swift
//  Server
//
//  Created by Guilherme Martins Dalosto de Oliveira on 22/09/20.
//  Copyright © 2020 Daniel Leal. All rights reserved.
//

import Foundation

struct TerrainModel: Codable, Identifiable{
    // MARK - Variables
    var id: UUID
    var name: String
    
    // MARK - Initializer
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self,forKey: .id)
        name = try values.decode(String.self,forKey: .name)
    }
}

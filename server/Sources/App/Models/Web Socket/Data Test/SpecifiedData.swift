//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Foundation

struct SpecifiedData: Codable{
    
    // MARK - Variables
    var id: Int
    
    private enum CodingKeys: String, CodingKey{
        case id
    }
    
    // MARK - Initializer
    init(id: Int){
        self.id = id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
    }
}

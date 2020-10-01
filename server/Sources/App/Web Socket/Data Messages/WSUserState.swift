//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 01/10/20.
//

import Foundation

struct WSUserState: Codable{
    internal private(set) var respUserID: UUID
    internal private(set) var destTeamID: UUID
    internal private(set) var stageID: UUID
    
    init(_ resp: UUID,_ dest: UUID,_ stage: UUID){
        self.respUserID = resp
        self.destTeamID = dest
        self.stageID = stage        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        respUserID = try values.decode(UUID.self,forKey: .respUserID)
        destTeamID = try values.decode(UUID.self,forKey: .destTeamID)
        stageID = try values.decode(UUID.self, forKey: .stageID)
    }
    
}

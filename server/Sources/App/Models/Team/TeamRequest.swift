//
//  File.swift
//  
//
//  Created by Antonio Carlos on 16/10/20.
//

import Vapor

struct TeamRequest: Content {
    var id: UUID
    var name: String
    var description: String
    var employeeToken: String
    var guestToken: String
    var image: Data
    var activeUsers: [UUID]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(UUID.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.description = try values.decode(String.self, forKey: .description)
        self.employeeToken = try values.decode(String.self, forKey: .employeeToken)
        self.guestToken = try values.decode(String.self, forKey: .guestToken)
        self.image = try values.decode(Data.self, forKey: .image)
        do {
            self.activeUsers = try values.decode([UUID].self, forKey: .activeUsers)
            if self.activeUsers.count == 0 {
                throw TeamErrors.arrayError
            }
        } catch {
            self.activeUsers = try [values.decode(UUID.self, forKey: .activeUsers)]
        }
    }
}

extension TeamRequest {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case employeeToken
        case guestToken
        case image
        case activeUsers
    }
    
    enum TeamErrors: Error {
        case arrayError
    }
}

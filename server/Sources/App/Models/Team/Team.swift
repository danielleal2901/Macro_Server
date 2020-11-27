//
//  File.swift
//  
//
//  Created by Antonio Carlos on 16/10/20.
//

import Fluent
import Vapor

final class Team: Model {
    
    static let schema = "teams"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name:String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "image")
    var image: Data
    
    @Field(key: "employee_token")
    var employeeToken: String
    
    @Field(key: "guest_token")
    var guestToken: String
    
    @Field(key: "activeUsers")
    var activeUsers: [UUID]
    
    init() {}
    
    init(id: UUID? = nil, name: String, description: String, image: Data, employeeToken: String, guestToken: String,activeUsers: [UUID]) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.employeeToken = employeeToken
        self.guestToken = guestToken
        self.activeUsers = activeUsers
    }
}

extension Team {
    public static func removeActiveUsersFromAllTeams(db: Database) {
        _ = Team.query(on: db).all().mapEach { (team) -> Void in
            team.activeUsers = []
            _ = team.update(on: db)
        }
    }
}

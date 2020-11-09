//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 06/11/20.
//

import Fluent
import Foundation
import Vapor



final class Marker: Model, Content {
    
    static let schema = "markers"
    
    struct Inoutput: Content {
        var id: UUID
        var title: String
        var color: [Double]
        var isSelected: Bool = false
    }    
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "color")
    var color: [Double]
    
    @Field(key: "isSelected")
    var isSelected: Bool
    
    @Parent(key: "status_id")
    var status: Status
    
    init() {}
    
    init(id: UUID = UUID(), title: String, color: [Double],statusID: UUID) {
        self.id = id
        self.title = title
        self.color = color
        self.isSelected = false
        self.$status.id = statusID
    }
}
extension Marker: Equatable{
    static func == (lhs: Marker,rhs: Marker) -> Bool{
        return rhs.id == lhs.id
    }
}

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
        let id: UUID
        let stageId: UUID
        let sections: [DocumentSection]
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "color")
    var color: [Double]
    
    @Field(key: "isSelected")
    var isSelected: Bool
    
    init() {}
    
    init(id: UUID = UUID(), title: String, color: [Double],isSelected: Bool) {
        self.id = id
        self.title = title
        self.color = color
        self.isSelected = false
    }
}

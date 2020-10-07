//
//  File.swift
//  
//
//  Created by Daniel Leal on 05/10/20.
//

import Foundation
import Vapor
import Fluent

final class Files: Model, Content {

    static let schema = "files"
    
    struct Inoutput : Content {
        let id: UUID
        let data: Data
        let itemId: UUID
        let documentId: UUID
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "document_id")
    var document: Document
    
    @Field(key: "data")
    var data: Data
    
    @Field(key: "item_id")
    var itemId: UUID
    
    init(){}
    
    init(id: UUID = UUID(), itemId: UUID, documentId: UUID, data: Data) {
        self.id = id
        self.itemId = itemId
        self.$document.id = documentId
        self.data = data
    }

}



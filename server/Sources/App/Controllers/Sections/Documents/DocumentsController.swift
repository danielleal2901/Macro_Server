//
//  File.swift
//  
//
//  Created by Jose Deyvid on 18/09/20.
//

import Foundation
import Vapor

class DocumentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        
        //document
        let documentsMain = routes.grouped(DocumentRoutes.getPathComponent(.main))
        
        documentsMain.get(use: fetchAllDocuments(req:))

        //document/documentId
        documentsMain.group(DocumentRoutes.getPathComponent(.id)) { (document) in
            document.get(use: fetchDocById(req:))
            document.put(use: updateItemDoc(req:))
        }
    
        //document/stage
        documentsMain.group(DocumentRoutes.getPathComponent(.withStage)) { (document) in
        
            //document/stage/stageId
            document.group(DocumentRoutes.getPathComponent(.stageId)) { (document) in
            }
        }
        
    
    }
    
    func insertDocument(req: Request) throws -> EventLoopFuture<Document> {
        let doc = try req.content.decode(Document.self)
        return doc.create(on: req.db).map({ doc })
    }
    
    func fetchAllDocuments(req: Request) throws -> EventLoopFuture<[Document]> {
        return Document.query(on: req.db).all()
    }
    
    func fetchDocById(req: Request) throws -> EventLoopFuture<Document> {
        return Document.find(req.parameters.get(DocumentParameters.documentId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteDocById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(DocumentParameters.documentId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Document.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func updateItemDoc(req: Request) throws -> EventLoopFuture<Document> {
        guard let id = req.parameters.get(DocumentParameters.documentId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let decodeQuery = try req.query.decode(DocumentItemQuery.self)
        let sectionName = decodeQuery.sectionName
        let itemName = decodeQuery.itemName
        
        let newItem = try req.content.decode(DocumentItem.self)
        
        return Document.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { (oldDocument) in
                var flagItem = false
                var flagSection = false

                for i in 0..<oldDocument.sections.count {
                    var section = oldDocument.sections[i]
                    
                    if section.name == sectionName{
                        flagSection = true
                        for y in 0..<section.items.count{
                            var item = section.items[y]
                            if item.name == newItem.name, item.format == newItem.format{
                                item.content = newItem.content
                                flagItem = true
                            }
                        }
                        if (!flagItem){
                            section.items.append(newItem)
                            flagItem = true
                        }
                    }
                    
                }
                
                if (!flagSection){
                    throw (Abort(.notFound))
                }
            
                return Document(id: try oldDocument.requireID(), stageId: oldDocument.$stage.id, sections: oldDocument.sections)
                
        }
                
//        }.flatMap { (document) -> EventLoopFuture<Document> in
//            return document.save(on: req.db).map({ document })
//        }
    }
    
}

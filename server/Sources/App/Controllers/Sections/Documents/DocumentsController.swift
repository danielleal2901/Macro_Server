//
//  File.swift
//  
//
//  Created by Jose Deyvid on 18/09/20.
//

import Foundation
import Vapor

class DocumentsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let doc = routes.grouped(DocumentsRoutes.getPathComponent(.main))
        doc.post(use: insertDocument)
        doc.get(use: fetchAllDocuments)
        doc.group(DocumentsRoutes.getPathComponent(.id)) { (doc) in
            doc.delete(use: deleteDocById)
            doc.get(use: fetchDocById)
            doc.put(use: updateDocById)
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
        return Document.find(req.parameters.get(DocumentsRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteDocById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(DocumentsRoutes.id.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Document.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func updateDocById(req: Request) throws -> EventLoopFuture<Document> {
        guard let id = req.parameters.get(DocumentsRoutes.id.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let newDocument = try req.content.decode(Document.self)
        return Document.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (oldDocument) -> EventLoopFuture<Document> in
                oldDocument.format = newDocument.format
                return oldDocument.save(on: req.db).map({ oldDocument })
        }
    }
}

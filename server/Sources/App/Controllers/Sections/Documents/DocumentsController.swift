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
            
            //document/documentId/section/sectionId
            document.group(DocumentRoutes.getPathComponent(.sectionId)) { (document) in
            }
        }
        
        //document/stage
        documentsMain.group(DocumentRoutes.getPathComponent(.withStage)) { (document) in
            
            //document/stage/stageId
            document.group(DocumentRoutes.getPathComponent(.stageId)) { (document) in
                document.get(use: fetchDocByStageId(req:))
            }
        }
        
        
    }
    
    func insertDocument(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try req.auth.require(User.self)
        
        let input = try req.content.decode(Document.Inoutput.self)
        let doc = Document(id: input.id, stageId: input.stageId, sections: input.sections)
        return doc.create(on: req.db).map({ doc }).transform(to: .ok)
    }
    
    func fetchAllDocuments(req: Request) throws -> EventLoopFuture<[Document.Inoutput]> {
        try req.auth.require(User.self)
        
        return Document.query(on: req.db).all().map { allDocs in
            allDocs.map { doc in
                Document.Inoutput(id: doc.id!, stageId: doc.stage.id!, sections: doc.sections)
            }
        }
    }
    
    func fetchDocById(req: Request) throws -> EventLoopFuture<Document.Inoutput> {
        try req.auth.require(User.self)
        
        return Document.find(req.parameters.get(DocumentParameters.documentId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMapThrowing { optionalDoc in
                return Document.Inoutput(id: optionalDoc.id!, stageId: optionalDoc.$stage.id, sections: optionalDoc.sections)
        }
    }
    
    func fetchDocByStageId (req: Request) throws -> EventLoopFuture<Document.Inoutput> {
        try req.auth.require(User.self)
        
        guard let stageId = req.parameters.get((DocumentParameters.stageId.rawValue), as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Document.query(on: req.db)
            .filter("stage_id", .equal, stageId)
            .first().unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalDoc in
                Document.Inoutput(id: try optionalDoc.requireID(), stageId: optionalDoc.$stage.id, sections: optionalDoc.sections)
        }
        
    }
//
//    func deleteDocById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        guard let id = req.parameters.get(DocumentParameters.documentId.rawValue, as: UUID.self) else {
//            throw Abort(.badRequest)
//        }
//
//        return Document.find(id, on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap({$0.delete(on: req.db)})
//            .transform(to: .ok)
//    }
//
    
}



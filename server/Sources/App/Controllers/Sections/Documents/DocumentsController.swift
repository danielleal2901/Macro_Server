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
                document.put(use: uploadItem(req:))
                
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
        let doc = try req.content.decode(Document.Inoutput.self)
        return doc.create(on: req.db).map({ doc }).transform(to: .ok)
    }
    
    func fetchAllDocuments(req: Request) throws -> EventLoopFuture<[Document.Inoutput]> {
        return Document.query(on: req.db).all().map { allDocs in
            allDocs.map { doc in
                Document.Inoutput(id: doc.id!, stageId: doc.stage.id!, sections: doc.sections)
            }
        }
    }
    
    func fetchDocById(req: Request) throws -> EventLoopFuture<Document.Inoutput> {
        return Document.find(req.parameters.get(DocumentParameters.documentId.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound)).map { optionalDoc in
                return Document.Inoutput(id: optionalDoc.id!, stageId: optionalDoc.stage.id!, sections: optionalDoc.sections)
        }
    }
    
    func fetchDocByStageId (req: Request) throws -> EventLoopFuture<Document.Inoutput> {
        
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
    
    func deleteDocById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(DocumentParameters.documentId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Document.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func uploadItem(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(DocumentParameters.documentId.rawValue, as: UUID.self),
            let sectionId = req.parameters.get(DocumentParameters.sectionId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let newItem = try req.content.decode(DocumentItem.self)
        
        return Document.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { (oldDocument) -> Document in
                
                var flagItem = false
                var flagSection = false
                
                for i in 0..<oldDocument.sections.count {
                    if oldDocument.sections[i].id == sectionId{
                        flagSection = true
                        for y in 0..<oldDocument.sections[i].items.count{
                            if oldDocument.sections[i].items[y].id == newItem.id {
                                oldDocument.sections[i].items[y].content = newItem.content
                                flagItem = true
                            }
                        }
                        if (!flagItem){
                            oldDocument.sections[i].items.append(newItem)
                            flagItem = true
                        }
                    }
                    
                }
                
                if (!flagSection){
                    throw (Abort(.notFound))
                }
                
                return oldDocument
        }.flatMap { (document) -> EventLoopFuture<HTTPStatus> in
            //            return document.update(on: req.db).transform(to: Document(id: document.id!, stageId: document.$stage.id, sections: document.sections))
            return document.update(on: req.db).transform(to: .ok)
        }
        
    }
    
//    func deleteItemDoc(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        guard let id = req.parameters.get(DocumentParameters.documentId.rawValue, as: UUID.self),
//            let itemId = req.parameters.get(DocumentParameters.itemId.rawValue, as: UUID.self),
//            let sectionId = req.parameters.get(DocumentParameters.sectionId.rawValue, as: UUID.self) else {
//                throw Abort(.badRequest)
//        }
//
//        return Document.find(id, on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMapThrowing { (document) -> Document in
//
//                var flagItem = false
//                var flagSection = false
//
//                for i in 0..<document.sections.count {
//                    if document.sections[i].id == sectionId{
//                        flagSection = true
//                        for y in 0..<document.sections[i].items.count{
//                            if document.sections[i].items[y].id == itemId{
//                                document.sections[i].items.remove(at: y)
//                                flagItem = true
//                            }
//                        }
//                    }
//
//                }
//
//                if (!flagItem){
//                    throw (Abort(.notFound))
//                }
//                if (!flagSection){
//                    throw (Abort(.notFound))
//                }
//
//
//                return document
//        }.flatMap { (document) -> EventLoopFuture<HTTPStatus> in
//            //            return document.update(on: req.db).transform(to: Document(id: document.id!, stageId: document.$stage.id, sections: document.sections))
//            return document.update(on: req.db).transform(to: .ok)
//        }
//
//
//    }
    
    
}



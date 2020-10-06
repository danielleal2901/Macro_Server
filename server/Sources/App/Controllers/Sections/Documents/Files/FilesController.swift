//
//  File.swift
//  
//
//  Created by Daniel Leal on 05/10/20.
//

import Foundation
import Vapor
import Fluent

class FilesController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        //files
        let filesMain = routes.grouped(FilesRoutes.getPathComponent(.main))
        
        filesMain.get(use: fetchAllFiles(req:))
        
        //files/fileId
        filesMain.group(FilesRoutes.getPathComponent(.id)) { (files) in
            files.get(use: fetchFileById(req: ))
        }
        
        //files/document
        filesMain.group(FilesRoutes.getPathComponent(.withDocument)) { (files) in
            //files/document/documentId
            files.group(FilesRoutes.getPathComponent(.documentId)) { (files) in
                files.get(use: fetchFilesByDocumentId(req: ))
                
                //files/document/documentId/item/
                files.group(FilesRoutes.getPathComponent(.withItem)) { (files) in
                    
                    //files/document/documentId/item/itemId
                    files.group(FilesRoutes.getPathComponent(.itemId)) { (files) in
                        files.get(use: fetchByDocumentAndItemId(req: ))
                        files.post(use: insertFile(req: ))
                    }
                    
                }
                
            }
            
            //            //files/document/id/item/id
            
        }
    }
    
    
    func fetchAllFiles(req: Request) throws -> EventLoopFuture<[Files.Inoutput]> {
        return Files.query(on: req.db).all().mapEach { files in
            return Files.Inoutput(id: files.id!, data: files.data, itemId: files.itemId, documentId: files.$document.id)
        }
    }
    
    func fetchFileById(req: Request) throws -> EventLoopFuture<Files.Inoutput> {
        guard let fileId = req.parameters.get(FilesParameters.id.rawValue, as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        return Files.find(fileId, on: req.db)
            .unwrap(or: Abort(.notFound)).map { optionalFile in
                return Files.Inoutput(id: optionalFile.id!, data: optionalFile.data, itemId: optionalFile.itemId, documentId: optionalFile.$document.id)
        }
    }
    
    func fetchFilesByDocumentId(req: Request) throws -> EventLoopFuture<[Files.Inoutput]> {
        guard let documentId = req.parameters.get(FilesParameters.documentId.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Files.query(on: req.db)
            .filter("document_id", .equal, documentId)
            .all().mapEach { files in
                return Files.Inoutput(id: files.id!, data: files.data, itemId: files.itemId, documentId: files.$document.id)
        }
        
    }
    
    func fetchByDocumentAndItemId(req: Request) throws -> EventLoopFuture<Files.Inoutput> {
        
        guard let documentId = req.parameters.get(FilesParameters.documentId.rawValue, as: UUID.self),
            let itemId = req.parameters.get(FilesParameters.itemId.rawValue, as: UUID.self)
            else {
                throw Abort(.notFound)
        }
        
        return Files.query(on: req.db).group(.and) { group in
            group.filter("document_id", .equal, documentId).filter("item_id", .equal, itemId)
        }
        .first()
        .unwrap(or: Abort(.notFound))
        .map { file in
            Files.Inoutput(id: file.id!, data: file.data, itemId: file.itemId, documentId: file.$document.id)
        }
        
    }
    
    func insertFile(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let newFile = try req.content.decode(Files.Inoutput.self)
        let file = Files(id: newFile.id, itemId: newFile.itemId, documentId: newFile.documentId, data: newFile.data)
        
        return file.create(on: req.db).map({ newFile }).transform(to: .ok)
    }
    
}

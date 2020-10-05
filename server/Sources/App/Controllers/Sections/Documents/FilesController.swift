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
        
        filesMain.get(use: fetchAllDocuments(req:))

        //files/fileId
        filesMain.group(FilesRoutes) { (files) in
            files.get(use: fetchFileById(req: ))
        }
        
    }
    

    func fetchAllFiles(req: Request) throws -> EventLoopFuture<[Files.Inoutput]> {
        return Files.query(on: req.db).all().mapEach { files in
            return Files.Inoutput(id: files.id!, data: files.data, itemId: files.itemId)
        }
    }
    
    func fetchFileById(req: Request) throws -> EventLoopFuture<Files.Inoutput> {
        guard let fileId = req.parameters.get(FilesParameters.id.rawValue, as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        return Files.find(fileId, on: req.db)
            .unwrap(or: Abort(.notFound)).map { optionalFile in
                return Files.Inoutput(id: optionalFile.id!, data: optionalFile.data, itemId: optionalFile.itemId)
        }
    }
    
    func fetchFilesByDocumentId(req: Request) throws -> EventLoopFuture<[Files.Inoutput]> {
        guard let documentId = req.parameters.get(FilesParameters.documentId.rawValue, as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        return Files.query(on: req.db)
            .filter("document_id", .equal, documentId)
            .all().mapEach { files in
                return Files.Inoutput(id: files.id!, data: files.data, itemId: files.itemId)
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
                .first().unwrap(or: Abort(.notFound))
                .map { optionalFile in
                    Files.Inoutput(id: optionalFile.id!, data: optionalFile.data, itemId: optionalFile.itemId)
            }
        }
        
    }
    
    func insertFile(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard
            let documentId = req.parameters.get(FilesParameters.documentId.rawValue, as: UUID.self),
            let itemId = req.parameters.get(FilesParameters.itemId.rawValue, as: UUID.self)
            else {
            throw Abort(.notFound)
        }
        
        let newFile = try req.content.decode(Files.Inoutput.self)
        
        return newFile.create(on: req.db).map({ newFile }).transform(to: .ok)

    }
        
}

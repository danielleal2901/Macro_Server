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
                        
                        files.get(use: downloadFile(req: ))
                        
                        files.on(.POST, body: .stream) { req in
                             try self.insertFile(req: req)
                        }
                        
                    }
                    
                }
                
            }
                
        }
//
//        routes.on(.POST, FilesRoutes.getPathComponent(.uploadFile), body: .stream) { req in
//            try self.insertFile(req: req)
//        }

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
    
    func downloadFile(req: Request) throws -> EventLoopFuture<Files.Inoutput> {
        
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

        guard let contentType = req.content.contentType, let boundary = contentType.parameters["boundary"] else {throw Abort(.badRequest)}

        let parser = MultipartParser(boundary: boundary)
        var parts: [MultipartPart] = []
        var headers: HTTPHeaders = [:]
        var body: String = ""

        parser.onHeader = { (field, value) in
            headers.replaceOrAdd(name: field, value: value)
        }
        parser.onBody = { new in
            let string = String(buffer: new)
            body += string
        }
        parser.onPartComplete = {
            let part = MultipartPart(headers: headers, body: body)
            headers = [:]
            body = ""
            parts.append(part)
        }

        let promise = req.eventLoop.makePromise(of: Bool.self)
        
        req.body.drain { part in
            switch part {
            case .buffer(let buffer):
                do {
                    try parser.execute(buffer)
                }catch (let error){
                    promise.completeWith(.failure(error))
                }
                return req.eventLoop.makeSucceededFuture(())
                
            case .error(let error):
                promise.completeWith(.failure(error))
                return req.eventLoop.makeSucceededFuture(())
                
            case .end:
                promise.completeWith(.success(true))
                return req.eventLoop.makeSucceededFuture(())
            }
        }
            
        return promise.futureResult.flatMapThrowing { result -> Files in
            if (!result){
                throw Abort(.badRequest)
            }
            
            guard let fileData = parts.firstPart(named: "data")?.body else {throw Abort(.badRequest)}
            guard let idBuffer = parts.firstPart(named: "id")?.body else {throw Abort(.badRequest)}
            guard let documentIdBuffer = parts.firstPart(named: "documentId")?.body else {throw Abort(.badRequest)}
            guard let itemIdBuffer = parts.firstPart(named: "itemId")?.body else {throw Abort(.badRequest)}
            
            //MARK: TODO -> Ler buffer e salvar o arquivo
            let id = String(buffer: idBuffer)
            let documentId = String(buffer: documentIdBuffer)
            let itemId = String(buffer: itemIdBuffer)
            let data = Data(buffer: fileData)
            
            let file = Files(id: UUID(uuidString: id)!, itemId: UUID(uuidString: itemId)!, documentId: UUID(uuidString: documentId)!, data: data)
            return file
        }.flatMap { (file)  in
            file.create(on: req.db).transform(to: .ok)
        }
        
    }

        

//        let newFile = try req.content.decode(Files.Inoutput.self)
//
//        let file = Files(id: newFile.id, itemId: newFile.itemId, documentId: newFile.documentId, data: newFile.data)
//
//        return file.create(on: req.db).map({ newFile }).transform(to: .ok)
    
    
}


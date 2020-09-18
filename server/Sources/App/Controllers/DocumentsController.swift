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
        doc.group(GeoRoutes.getPathComponent(.id)) { (geo) in
            geo.delete(use: deleteGeoById)
            geo.get(use: fetchGeoById)
            geo.put(use: updateGeoById)
        }
    }
    
    func insertDocument(req: Request) throws -> EventLoopFuture<Document> {
        let doc = try req.content.decode(Document.self)
        return doc.create(on: req.db).map({ doc })
    }
    
    func fetchAllDocuments(req: Request) throws -> EventLoopFuture<[Document]> {
        return Document.query(on: req.db).all()
    }
    
    func fetchGeoById(req: Request) throws -> EventLoopFuture<Georeferecing> {
        return Georeferecing.find(req.parameters.get(GeoRoutes.id.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteGeoById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(GeoRoutes.id.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Georeferecing.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({$0.delete(on: req.db)})
            .transform(to: .ok)
    }
    
    func updateGeoById(req: Request) throws -> EventLoopFuture<Georeferecing> {
        guard let id = req.parameters.get(GeoRoutes.id.rawValue, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let newGeoreferecing = try req.content.decode(Georeferecing.self)
        return Georeferecing.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (oldGeoreferecing) -> EventLoopFuture<Georeferecing> in
                oldGeoreferecing.name = newGeoreferecing.name
                return oldGeoreferecing.save(on: req.db).map({ oldGeoreferecing })
        }
    }
}

//
//  File.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 09/11/20.
//

import Foundation
import Vapor

class MarkerController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let markerMain = routes.grouped(MarkerRoutes.getPathComponent(.main))
        markerMain.post(use: insertMarker)
        
        markerMain.group(MarkerRoutes.getPathComponent(.id)) { marker in
            markerMain.get(use: fetchAllMarkersByStatusId)
            marker.put(use: updateMarkerById)
            marker.delete(use: deleteMarkerById)
        }
        
        markerMain.group(MarkerRoutes.getPathComponent(.status)) { marker in
            marker.group(MarkerRoutes.getPathComponent(.statusId)) { marker in
                marker.get(use: fetchAllMarkersByStatusId(req: ))
            }
        }
        
    }
        
    func insertMarker(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        
        let marker = try req.content.decode(Marker.self)
        return marker.create(on: req.db).transform(to: .ok)
    }
    
    func updateMarkerById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        
        
        let newMarker = try req.content.decode(Marker.self)
        
        guard let id = req.parameters.get(MarkerParameters.idMarker.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
        
        return Marker.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (marker) in
                marker.title = newMarker.title
                return marker.update(on: req.db).transform(to: .ok)
        }
    }
        
    func fetchAllMarkersByStatusId(req: Request) throws -> EventLoopFuture<[Marker]> {
        
        
        guard let id = req.parameters.get(MarkerParameters.idStatus.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
        return Marker.query(on: req.db)
            .filter("status_id", .equal, id)
            .all().map { allMarkers in
            allMarkers.map { marker in
                Marker(id: marker.id!, title: marker.title, color: marker.color, statusID: marker.$status.id)
            }
        }
    }
    
    func deleteMarkerById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        
        
        guard let id = req.parameters.get(MarkerParameters.idMarker.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
            
        return Marker.find(id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
            
    }
}


//
//  File.swift
//  
//
//  Created by Daniel Leal on 12/09/20.
//

import Foundation
import Vapor
import Fluent

class GeoController: RouteCollection, StageRoutesProtocol {

    func boot(routes: RoutesBuilder) throws {
        
        
//        let geo = routes.grouped(GeoRoutes.getPathComponent(.main))
//        geo.post(use: insertGeoreferecing)
//        geo.get(use: fetchAllGeo)
//        //With geoID
//        geo.group(GeoRoutes.getPathComponent(.id)) { (geo) in
//            geo.delete(use: deleteGeoById)
//            geo.get(use: fetchGeoById)
//            geo.put(use: updateGeoById)
//        }
//        //With terrainID
//        geo.group(GeoRoutes.getPathComponent(.withTerrain)) { (geo) in
//            geo.group(GeoRoutes.getPathComponent(.terrainId)) { (geo) in
//                geo.get(use: fetchGeoByTerrainID)
//            }
//        }
    }
}

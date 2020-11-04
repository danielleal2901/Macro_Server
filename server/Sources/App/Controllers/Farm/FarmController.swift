//
//  File.swift
//
//
//  Created by Daniel Leal on 20/10/20.
//

import Foundation
import Vapor
import Fluent

class FarmController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let farmMain = routes.grouped(FarmRoutes.getPathComponent(.main))
        farmMain.post(use: insertFarm)
        farmMain.get(use: fetchAllFarms)
        
        
        farmMain.group(FarmRoutes.getPathComponent(.id)) { farm in            
            farm.get(use: fetchFarmById)
            farm.put(use: updateFarmById)
            farm.delete(use: deleteFarmById)
        }
        
        farmMain.group(FarmRoutes.getPathComponent(.team)) { farm in
            farm.group(FarmRoutes.getPathComponent(.teamId)) { farm in
                farm.get(use: fetchAllFarmsByTeamId(req: ))
            }
        }

    }
    
    
    func insertFarm(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        let farm = try req.content.decode(Farm.self)
        
        return farm.create(on: req.db).flatMapThrowing {
            try self.setupTerritorialDiagnosisContainer(req: req, farmId: farm.id!).flatMapThrowing({ http in
                try self.setupSocialMobContainer(req: req, farmId: farm.id!).flatMapThrowing({ (http) in
                    try self.setupEnvironmentalContainer(req: req, farmId: farm.id!).flatMapThrowing({ (http) in
                        try self.setupDescMemorialContainer(req: req, farmId: farm.id!).transform(to: ())
                    })
                })
            })
            
        }.transform(to: .ok)

    }
    
    func updateFarmById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let newFarm = try req.content.decode(Farm.self)
        
        guard let id = req.parameters.get(FarmParameters.idFarm.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
        
        return Farm.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (farm) in
                farm.name = newFarm.name
                farm.desc = newFarm.desc
                farm.teamId = newFarm.teamId
                return farm.update(on: req.db).transform(to: .ok)
        }
    }

    func fetchFarmById(req: Request) throws -> EventLoopFuture<Farm.Inoutput> {
        return Farm.find(req.parameters.get(FarmParameters.idFarm.rawValue), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { optionalFarm in
                return Farm.Inoutput(id: optionalFarm.id!, name: optionalFarm.name, teamId: optionalFarm.teamId, icon: Data(), desc: optionalFarm.desc)
        }
    }
    
    func fetchAllFarms(req: Request) throws -> EventLoopFuture<[Farm.Inoutput]> {
            return Farm.query(on: req.db).all().map { allFarms in
                allFarms.map { farm in
                    Farm.Inoutput(id: farm.id!, name: farm.name, teamId: farm.teamId, icon: Data(), desc: farm.desc)
                }
            }
        }
    
    func fetchAllFarmsByTeamId(req: Request) throws -> EventLoopFuture<[Farm.Inoutput]> {
        
        guard let id = req.parameters.get(FarmParameters.teamId.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
        
        return Farm.query(on: req.db)
            .filter("teamId", .equal, id)
            .all().map { allFarms in
            allFarms.map { farm in
                Farm.Inoutput(id: farm.id!, name: farm.name, teamId: farm.teamId, icon: Data(), desc: farm.desc)
            }
        }
    }
    
    func deleteFarmById(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        guard let id = req.parameters.get(FarmParameters.idFarm.rawValue, as: UUID.self) else { throw Abort(.badRequest) }
            
        return Farm.find(id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db).transform(to: .ok)
        }
            
    }
    
    private func setupTerritorialDiagnosisContainer (req: Request, farmId: UUID) throws -> EventLoopFuture<HTTPStatus>{
        
        let dataManager = DataManager()
        
        let territorialStages : [StageTypes] = [.diagnosticData, .diagnosticDocumentaryResearch, .diagnosticLandResearch, .diagnosticTerritorialStudy, .diagnosticFinalReport, .diagnosticWorkPlan]
        let territorialDiagContainer = StagesContainer.Inoutput(type: .territorialDiagnosis, stages: territorialStages, id: UUID(), farmId: farmId, name: "Diagnóstico Territorial")
        
        return try dataManager.createContainer(containerInput: territorialDiagContainer, req: req)
    }
    
    private func setupSocialMobContainer (req: Request, farmId: UUID) throws -> EventLoopFuture<HTTPStatus>{
        
        let dataManager = DataManager()
        
        let socialStages : [StageTypes] = [.socialMobilizationData]
        
        let socialMobContainer = StagesContainer.Inoutput(type: .socialMobilization, stages: socialStages, id: UUID(), farmId: farmId, name: "Mobilização Social")
        
        return try dataManager.createContainer(containerInput: socialMobContainer, req: req)
    }
    
    private func setupEnvironmentalContainer (req: Request, farmId: UUID) throws ->  EventLoopFuture<HTTPStatus>{

        let dataManager = DataManager()

        let environmentStages : [StageTypes] = [.environmentalStudyData]

        let environmentContainer = StagesContainer.Inoutput(type: .environmentalStudy, stages: environmentStages, id: UUID(), farmId: farmId, name: "Estudo Ambiental")

        return try dataManager.createContainer(containerInput: environmentContainer, req: req)
    }
    
    private func setupDescMemorialContainer (req: Request, farmId: UUID) throws -> EventLoopFuture<HTTPStatus>{

        let dataManager = DataManager()

        let descMemorialStages : [StageTypes] = [.descriptiveMemorialData, .descriptiveMemorialGeoreferencing, .descriptiveMemorialTerritorialSurvey, .descriptiveMemorialPropertyRegistration, .descriptiveMemorialSocioeconomicRegistration, .descriptiveMemorialPropertyEvaluation]

        let descMemorialContainer = StagesContainer.Inoutput(type: .descriptiveMemorial, stages: descMemorialStages, id: UUID(), farmId: farmId, name: "Memorial Descritivo")

        return try dataManager.createContainer(containerInput: descMemorialContainer, req: req)
    }
}


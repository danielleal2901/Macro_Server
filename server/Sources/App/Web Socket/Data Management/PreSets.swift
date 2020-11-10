//
//  File.swift
//  
//
//  Created by Daniel Leal on 23/10/20.
//

import Foundation
import Vapor

final class PreSets {
    
    static func setupTerrainPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                let statusID = UUID()
                _ = stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Responsável", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db).map { _ in
                        return Document(stageId: stage.id!, sections: [DocumentSection(name: "Marcados", items: []), DocumentSection(name: "Outros", items: [])]).create(on: req.db).map { _   in
                                return Status(id: statusID,stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Fazer relatório", status: .todo, tags: [], resp: [])]).create(on: req.db).map { _ in
                                    return createMarkerPreset(req: req, statusID: statusID)
                                }
                            }
                        }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupDiagnosisPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                let statusID = UUID()
               _ =  stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(id: statusID,stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db).map { _ in
                                        return createMarkerPreset(req: req, statusID: statusID)
                                    }
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupSocialMobPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                let statusID = UUID()
                _ = stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(id: statusID,stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db).map { _ in
                                        return createMarkerPreset(req: req, statusID: statusID)
                                    }
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupEnvironmentalPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                let statusID = UUID()
                _ = stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(id: statusID,stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db).map { _ in
                                        return createMarkerPreset(req: req, statusID: statusID)
                                    }
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupDescriptiveMemPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                let statusID = UUID()
                _ = stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(id: statusID,stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db).map { _ in
                                        return createMarkerPreset(req: req, statusID: statusID)
                                    }
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func createMarkerPreset(req: Request,statusID: UUID) -> EventLoopFuture<HTTPStatus> {
        
        let markers: [Marker] = [.init(title: "Fácil", color: [187,221,191],statusID: statusID),
                       .init(title: "Médio", color: [221,211,187],statusID: statusID),
                       .init(title: "Difícil", color: [221,187,187],statusID: statusID),
                       .init(title: "Georreferenciamento", color: [224,224,224],statusID: statusID),
                       .init(title: "Morador", color: [221,187,221],statusID: statusID)]
        
        let promise = req.eventLoop.makePromise(of: Void.self)
        
        _ = markers.map { marker in
            marker.create(on: req.db).map { _ in
                if marker == markers.last {
                    promise.succeed(())
                }
            }
        }
        return promise.futureResult.transform(to: .ok)
        
    }
    
}


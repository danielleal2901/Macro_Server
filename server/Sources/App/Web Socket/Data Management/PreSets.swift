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
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Responsável", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Fazer relatório", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db)
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupDiagnosisPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db)
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupSocialMobPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db)
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupEnvironmentalPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db)
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    static func setupDescriptiveMemPreSet(newContainer: StagesContainer, req: Request, stages: [Stage]) -> EventLoopFuture<HTTPStatus>{
        return newContainer.create(on: req.db).map { _ in
            stages.map { stage in
                stage.create(on: req.db).map { _ in
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Nome", value: "ABPRU")])]).create(on: req.db)
                        .map { _ in
                            return Status(stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Arrumar a cama", status: .todo, tags: [], resp: [])]).create(on: req.db)
                                .map { _ in
                                    return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db)
                            }
                    }
                }
            }
        }.transform(to: .ok)
    }
    
    
}


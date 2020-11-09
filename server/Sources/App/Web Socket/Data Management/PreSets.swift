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
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Dados Gerais", value: "")]),
                                                                   OverviewSection(name: "Informações do Responsável", items: [OverviewItem(key: "Dados Gerais", value: "")])
                                                                  ]).create(on: req.db).map { _ in
                        return Document(stageId: stage.id!, sections: [DocumentSection(name: "Importantes", items: [])]).create(on: req.db).map { _   in
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
                    return Overview(stageId: stage.id!, sections:
                                        [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Dados Gerais", value: "")]),
                                         OverviewSection(name: "Informações do Responsável", items: [OverviewItem(key: "Dados Gerais", value: "")])
                                        ]).create(on: req.db)
                        .map { _ in
                            return Status(id: statusID,stageId: stage.id!, tasks:
                                            [Task.init(id: UUID(), title: "Coleta de elementos descritivos - Memoriais, matrículas e etc", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Buscar documentos em órgãos públicos e cartórios", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Realizar Cartografia Básica: Georeferenciamento", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Levantamento de Potencialidades e Fragilidades", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Levantamento de Características Históricas, Físicas e Geográficas", status: .todo, tags: [], resp: []),
                                            ]).create(on: req.db)
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
                    return Overview(stageId: stage.id!, sections:
                                        [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Dados Gerais", value: "")]),
                                         OverviewSection(name: "Informações do Responsável", items: [OverviewItem(key: "Dados Gerais", value: "")])
                                        ]).create(on: req.db)
                        .map { _ in
                            return Status(id: statusID,stageId: stage.id!, tasks:
                                            [Task.init(id: UUID(), title: "Estabelecer Licença social", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Assegurar condições de acompanhamento da comunidade", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Realizar evento de encerramento das atividades do Projeto de Trabalho Social", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Apresentar resultado de pesquisa de pós ocupação", status: .todo, tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Revelar o nível de satisfação da população beneficiada", status: .todo, tags: [], resp: []),
                                             
                                             
                                             
                                            ]).create(on: req.db)
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
                    return Overview(stageId: stage.id!, sections:
                                        [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Dados Gerais", value: "")]),
                                         OverviewSection(name: "Informações do Responsável", items: [OverviewItem(key: "Dados Gerais", value: "")])
                                        ]).create(on: req.db)
                                            .map { _ in
                                                return Status(id: statusID,stageId: stage.id!, tasks:
                                                                [Task.init(id: UUID(), title: "Contratar órgão ambiental", status: .todo, tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Verificar tipo de licença necessária", status: .todo, tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Contratar Profissionais", status: .todo, tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Coletar Relatórios técnicos", status: .todo, tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Submeter relatórios ao órgão ambiental", status: .todo, tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Obter licença ambiental", status: .todo, tags: [], resp: []),
                                                                ]).create(on: req.db)
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
                    return Overview(stageId: stage.id!, sections: [OverviewSection(name: "Informações Principais", items: [OverviewItem(key: "Dados Gerais", value: "")]),
                                                                   OverviewSection(name: "Informações do Responsável", items: [OverviewItem(key: "Dados Gerais", value: "")])
                                                                  ]
                    ).create(on: req.db)
                    .map { _ in
                        return Status(id: statusID,stageId: stage.id!, tasks:
                                        [Task.init(id: UUID(), title: "Contratar empresa especializada, com CREA", status: .todo, tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Realizar Georeferenciamento", status: .todo, tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Cadastramento dos Ocupantes", status: .todo, tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Codificar e Vistoriar os Lotes", status: .todo, tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Obter Planilha .ods", status: .todo, tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Obter Mapas", status: .todo, tags: [], resp: [])
                                        ]).create(on: req.db)
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
                                 .init(title: "Documento", color: [224,224,224],statusID: statusID),
                                 .init(title: "Contrato", color: [221,187,221],statusID: statusID)]
        
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


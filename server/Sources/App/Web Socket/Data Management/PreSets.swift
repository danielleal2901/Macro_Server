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
                        return Document(stageId: stage.id!, sections: [DocumentSection(name: "Marcados", items: []), DocumentSection(name: "Outros", items: [])]).create(on: req.db).map { _   in
                            return Status(id: statusID,stageId: stage.id!, tasks: [Task.init(id: UUID(), title: "Fazer relatório", columnTitle: "Fazer", tags: [], resp: [])]).create(on: req.db).map { _ in
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
                                            [Task.init(id: UUID(), title: "Coleta de elementos descritivos - Memoriais, matrículas e etc", columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Buscar documentos em órgãos públicos e cartórios", columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Realizar Cartografia Básica: Georeferenciamento", columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Levantamento de Potencialidades e Fragilidades",  columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Levantamento de Características Históricas, Físicas e Geográficas",  columnTitle: "Fazer", tags: [], resp: []),
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
                                            [Task.init(id: UUID(), title: "Estabelecer Licença social", columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Assegurar condições de acompanhamento da comunidade",  columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Realizar evento de encerramento das atividades do Projeto de Trabalho Social", columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Apresentar resultado de pesquisa de pós ocupação", columnTitle: "Fazer", tags: [], resp: []),
                                             Task.init(id: UUID(), title: "Revelar o nível de satisfação da população beneficiada", columnTitle: "Fazer", tags: [], resp: []),
                                             
                                             
                                             
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
                                                                [Task.init(id: UUID(), title: "Contratar órgão ambiental", columnTitle: "Fazer", tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Verificar tipo de licença necessária", columnTitle: "Fazer", tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Contratar Profissionais", columnTitle: "Fazer", tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Coletar Relatórios técnicos", columnTitle: "Fazer", tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Submeter relatórios ao órgão ambiental", columnTitle: "Fazer", tags: [], resp: []),
                                                                 Task.init(id: UUID(), title: "Obter licença ambiental", columnTitle: "Fazer", tags: [], resp: []),
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
                                        [Task.init(id: UUID(), title: "Contratar empresa especializada, com CREA", columnTitle: "Fazer", tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Realizar Georeferenciamento", columnTitle: "Fazer", tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Cadastramento dos Ocupantes", columnTitle: "Fazer", tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Codificar e Vistoriar os Lotes", columnTitle: "Fazer", tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Obter Planilha .ods", columnTitle: "Fazer", tags: [], resp: []),
                                         Task.init(id: UUID(), title: "Obter Mapas", columnTitle: "Fazer", tags: [], resp: [])
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


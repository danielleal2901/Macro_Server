//
//  DataManagerLogic.swift
//  
//
//  Created by Guilherme Martins Dalosto de Oliveira on 28/09/20.
//

import Vapor
import Foundation

typealias DataManagerLogic = ContainerManagement & StageManagement & OverviewManagement & StatusManagement

protocol ContainerManagement{

    func createContainer(containerInput: StagesContainer.Inoutput,req: Request) throws -> EventLoopFuture<HTTPStatus>
    func updateContainer(req: Request, newContainer: StagesContainer.Inoutput) throws -> EventLoopFuture<HTTPStatus>
    func deleteContainer(req: Request, container: StagesContainer.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol StageManagement{
    func updateStage(req: Request,newStage: Stage.Inoutput) throws -> EventLoopFuture<HTTPStatus>
    func deleteStage(req: Request,stage: Stage.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol OverviewManagement{
    func updateOverview(req: Request,newOverview: Overview.Inoutput) throws -> EventLoopFuture<HTTPStatus>
    func deleteOverview(req: Request,overview: Overview.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol StatusManagement{
    func updateStatus(req: Request,newStatus: Status.Inoutput) throws -> EventLoopFuture<HTTPStatus>
    func deleteStatus(req: Request,status: Status.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol DocumentManagement {
    func createDocument(req: Request, documentInoutput: Document.Inoutput) throws -> EventLoopFuture<HTTPStatus> 
    func updateDocument(req: Request,newStatus: Document.Inoutput) throws -> EventLoopFuture<HTTPStatus>
    func deleteDocument(req: Request,status: Document.Inoutput) throws -> EventLoopFuture<HTTPStatus>
}

protocol UserManagement {
    func updateUser(req: Request, newUser: User) throws -> EventLoopFuture<HTTPStatus>
    func deleteUser(req: Request, user: User) throws -> EventLoopFuture<HTTPStatus>
}

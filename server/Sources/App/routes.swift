import Fluent
import Vapor
import Mailgun

func routes(_ app: Application) throws {
    
    
    app.post("mail") { req -> EventLoopFuture<HTTPStatus> in
        let mailPackage = try req.content.decode(MailPackage.self)
        
        return User.query(on: req.db)
            .filter("email", .equal, mailPackage.email).all().map { user in
                if !user.isEmpty{
                let password = user.first?.password
                    let message = MailgunMessage(
                        from: "Regularize <regularizeapp@gmail.com>",
                        to: "\(mailPackage.email)",
                        subject: "Regularize - Recuperação de Senha",
                        text: """
                        Olá \(user.first!.name.uppercased()), nos foi submetido uma requisição informando que você esqueceu sua senha em nossa aplicação.
                        Caso não tenha solicitado nenhuma informação, favor desconsidere a mensagem.
                        O token para redefinição de sua senha é \(String(describing: password!.prefix(12)))

                        Atenciosamente Equipe da Regularize
                        """                        
                    )
                    let value = req.mailgun(.mainDomain).send(message)
                    print(value.whenComplete({ (result) in
                        switch result{
                        case .success(let response):
                            print(response)
                        case .failure(let error):
                            print(error)
                        }
                    }))
                }
            }.transform(to: .ok)
    }
    
    app.post("passwordReset") { req -> EventLoopFuture<HTTPStatus> in
        let package = try req.content.decode(ResetPackage.self)        
        return User.query(on: req.db)
            .filter("email",.equal,package.email).all().map{ user in
                if user.first!.password.prefix(12) == package.token{
                    user.first?.password = try! Bcrypt.hash(package.password)
                    _ = user.first?.update(on: req.db)
                }
            }.transform(to: .ok)
    }
    
    //Do Login
    app.post("userlogin") { req -> EventLoopFuture<LoginPackage> in
        let authEntity = try req.content.decode(AuthEntity.self)
        
        return User.query(on: req.db).filter("email", .equal, authEntity.email).first().unwrap(or: Abort(.notFound, reason: "Usuário ou senha inválidos.")).flatMap { (user) in
            
            let promise = req.eventLoop.makePromise(of: LoginPackage.self)
            do {
                if try !Bcrypt.verify(authEntity.password, created: user.password) {
                    promise.fail(Abort(.unauthorized, reason: "Usuário ou senha inválidos."))
                }
            } catch {
                promise.fail(Abort(.badRequest))
            }
            
            do {
                let token = try user.generateToken()
                let response = LoginPackage(user: UserResponse(id: user.id!, name: user.name, email: user.email, password: user.password, isAdmin: user.isAdmin, image: user.image, teamId: user.$team.id), userToken: token)
                
                token.save(on: req.db).whenSuccess { (_) in
                    promise.succeed(response)
                }
            } catch {
                promise.fail(Abort(.badRequest))
            }
            
            return promise.futureResult
        }
    }
    
    let tokenProtected = app.grouped(UserToken.authenticator()).grouped(UserToken.guardMiddleware())
    
    try tokenProtected.register(collection: StagesContainerController())
    try tokenProtected.register(collection: StageController())
    try tokenProtected.register(collection: OverviewController())
    try tokenProtected.register(collection: StatusController())
    try tokenProtected.register(collection: DocumentController())
    try tokenProtected.register(collection: FilesController())
    try tokenProtected.register(collection: FarmController())
    try tokenProtected.register(collection: MarkerController())
    
    try app.register(collection: TeamController())
    try app.register(collection: UserController())
//    try app.register(collection: StagesContainerController())
//    try app.register(collection: StageController())
//    try app.register(collection: OverviewController())
//    try app.register(collection: StatusController())
//    try app.register(collection: DocumentController())
//    try app.register(collection: FilesController())
//    try app.register(collection: UserController())
//    try app.register(collection: FarmController())
//    try app.register(collection: MarkerController())
    
}

func webSockets(_ app: Application) throws{
    print("Creating connection")
    
    let dataController = WSInteractor()
    
    /// Aiming to add to a class
    /// Activesession for Web Socket Connection
    
    //    app.webSocket("UserConnection"){ request,ws in
    //        var currentUserID: UUID?
    //
    //        ws.onText{ (ws,data) in
    //            if let dataCov = data.data(using: .utf8){
    //                guard let message = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataCov, intendedType: WSConnectionPackage.self) else {return}
    //
    //                dataController.enteredUser(user: message.user, connection: ws, req: request)
    //                currentUserID = message.user.id
    //
    //                //                if let user = WSDataWorker.shared.connections.first(where: {
    //                //                    return $0.user.id == message.user.id
    //                //                }) {
    //                //                    currentUserID = user.userState.respUserID
    //                //                    dataController.changeStageState(userState: WSUserState(user.userState.name, user.userState.photo, user.userState.destTeamID, user.userState.respUserID, user.userState.containerID) ,connection: ws, req: request)
    //                //                }else{
    //                //                    dataController.enteredUser(userState: WSUserState(message.newUserState.name, message.newUserState.photo, message.newUserState.respUserID, message.newUserState.destTeamID, message.newUserState.containerID),connection: ws, req: request)
    //                //                    currentUserID = message.newUserState.respUserID
    //                //                }
    //            }
    //        }
    //
    //
    //
    
    //    }
    
    let tokenProtected = app.grouped(UserToken.authenticator()).grouped(UserToken.guardMiddleware())
    
    tokenProtected.webSocket("DataExchange", maxFrameSize: .init(integerLiteral: 1 << 30)) { request,ws in
        let currentWsId: UUID = UUID()
        // MARK - Variables
        // Actions for control of User Sessions
        
        ws.onText { (ws, data) in
            if let dataCov = data.data(using: .utf8){
                
                //Se for pacote de conexao
                if let message = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataCov, intendedType: WSConnectionPackage.self) {
                    
                    dataController.enteredUser(user: message.user, connection: ws, req: request, currentWsId: currentWsId)
                    
                    //Se for pacote de dados
                }else {
                    
                    // Make responsability to another class
                    guard let message = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataCov, intendedType: WSDataPackage.self) else { print("NAODEUSABOSTS");return}
                    switch message.operation{
                    case 0:
                        // INSERT DATA
                        dataController.addData(sessionRequest: request, dataMessage: .init(data: message)) { (response) in
                            switch response.actionStatus{
                            case .Completed:
                                print("Adicionou")
                            case .Error:
                                print()
                            default:
                                print()
                            }
                        }
                        break
                    case 1:
                        // FETCH DATA
                        dataController.fetchData(sessionID: request, dataMessage: .init(data: message)) { (response) in
                            switch response.actionStatus{
                            case .Completed:
                                let dataReceived = response.dataReceived
                                let encoded = CoderHelper.shared.encodeDataToString(valueToEncode: dataReceived)
                                ws.send(encoded)
                                print()
                            //                            dataController.broadcastData(data: convertedData!)
                            case .Error:
                                print()
                            default:
                                print()
                            }
                        }
                        break
                    case 2:
                        // UPDATE DATA
                        dataController.updateData(sessionID: request, dataMessage: .init(data: message)) { (response) in
                            print(response.actionStatus)
                        }
                        break
                    case 3:
                        // DELETE DATA
                        dataController.deleteData(sessionRequest: request, dataMessage: message) { (response) in
                            print(response.actionStatus)
                        }
                        break
                    case 4:
                        // adding user to a team
                        dataController.addUser(ws: ws, req: request,dataMessage: message).whenSuccess({ _ in })
                        break
                    default:
                        print()
                    }
                }
                
            }
            
        }
        
        ws.onBinary { (ws, binary) in
            print(binary)
        }
        
        
        ws.onClose.whenComplete { result in
            
            dataController.removeUserConnection(currentWsId: currentWsId, req: request)
            print("Ended Connection")
            // remover usuario
        }
        
        
    }
    
}



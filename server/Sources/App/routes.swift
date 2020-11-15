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
                        from: "Regularize-se <gmdalosto@gmail.com>",
                        to: "\(mailPackage.email)",
                        subject: "Regularize-se - Recuperação de Senha",
                        text: """
                        Olá \(user.first!.name.uppercased()), nos foi submetido uma requisição informando que você esqueceu sua senha em nossa aplicação.
                        Caso não tenha solicitado nenhuma informação, favor desconsidere a mensagem.
                        O token para redefinição de sua senha é \(String(describing: password!.prefix(12)))

                        Atenciosamente Equipe da Regularize-se
                        """                        
                    )
                    _ = req.mailgun(.mainDomain).send(message)
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
    
    
    
    
    //@gui -> Going to Change Path, using for testing
    //    app.post("userstates") { (req) -> EventLoopFuture<WSUserState> in
    //        let create = try req.content.decode(WSUserState.self)
    //        let state = WSUserState(create.name,create.photo,create.containerID,create.respUserID, create.destTeamID)
    //
    //        return User.find(state.respUserID, on: req.db)
    //            .unwrap(or: Abort(.notFound))
    //            .flatMap { (optionalUserState) -> EventLoopFuture<WSUserState> in
    //                state.name = optionalUserState.name
    //                state.photo = optionalUserState.name
    //                return state.save(on: req.db).transform(to: state)
    //        }
    //    }
    //
    //    //@gui - > Change to Post for specified with Team
    //    app.get("userStates",":teamid") { (req) -> EventLoopFuture<[WSUserState]> in
    //        if let teamID = req.parameters.get("teamid"){
    //            return WSUserState.query(on: req.db).filter("destTeamID", .equal, UUID(uuidString: teamID)).all()
    //        }
    //        return WSUserState.query(on: req.db).all()
    //    }
    
    //Creates an Administrator
    app.on(.POST, UserRoutes.getPathComponent(.main), body: .collect(maxSize: "20mb")) {req -> EventLoopFuture<LoginPackage> in
        let user = try req.content.decode(User.self)
        let userResponse = UserResponse(id: user.id!, name: user.name, email: user.email, password: user.password, isAdmin: user.isAdmin, image: user.image, teamId: user.$team.id)
        let token = try user.generateToken()
        let response = LoginPackage(user: userResponse, userToken: token)
        return user.save(on: req.db).transform(to: response)
    }
    
    //Creates an User
    app.on(.POST, UserRoutes.getPathComponent(.employeeToken), body: .collect(maxSize: "20mb")) { req -> EventLoopFuture<LoginPackage> in
        guard let employeeToken = req.parameters.get(UserParameters.employeeToken.rawValue) else {
            throw Abort(.notFound)
        }
        
        let promise = req.eventLoop.makePromise(of: LoginPackage.self)
        
        return Team.query(on: req.db)
            .filter(\.$employeeToken == employeeToken)
            .first()
            .unwrap(or: Abort(.unauthorized, reason: "Token de Acesso Inválido"))
            .flatMapThrowing { (optionalTeam) -> User in
                let team = Team(id: optionalTeam.id, name: optionalTeam.name, description: optionalTeam.description, image: optionalTeam.image, employeeToken: optionalTeam.employeeToken, guestToken: optionalTeam.guestToken,activeUsers: [])
                
                let user = try req.content.decode(User.self)
                user.$team.id = team.id!
                return user
            }.flatMap { (user) in
                do {
                    let userResponse = UserResponse(id: user.id!, name: user.name, email: user.email, password: user.password, isAdmin: user.isAdmin, image: user.image, teamId: user.$team.id)
                    let token = try user.generateToken()
                    let response = LoginPackage(user: userResponse, userToken: token)
                    user.save(on: req.db).whenSuccess { (_) in
                        promise.succeed(response)
                    }
                } catch {
                    promise.fail(Abort(.badRequest))
                }
                return promise.futureResult
            }
    }
    
    //Do Login
    app.post("userlogin") { req -> EventLoopFuture<LoginPackage> in
        let authEntity = try req.content.decode(AuthEntity.self)
        
        return User.query(on: req.db).filter("email", .equal, authEntity.email).first().unwrap(or: Abort(.notFound)).flatMap { (user) in
            
            let promise = req.eventLoop.makePromise(of: LoginPackage.self)
            do {
                if try !Bcrypt.verify(authEntity.password, created: user.password) {
                    promise.fail(Abort(.unauthorized))
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
    
    //    let tokenProtected = app.grouped(UserToken.authenticator())
    //
    //    tokenProtected.get("me") { req -> User in
    //        try req.auth.require(User.self)
    //    }
    
    let tokenProtected = app.grouped(UserToken.authenticator()).grouped(UserToken.guardMiddleware())
    
    
//    try tokenProtected.register(collection: StagesContainerController())
//    try tokenProtected.register(collection: StageController())
//    try tokenProtected.register(collection: OverviewController())
//    try tokenProtected.register(collection: StatusController())
//    try tokenProtected.register(collection: DocumentController())
//    try tokenProtected.register(collection: FilesController())
//    try tokenProtected.register(collection: UserController())
//    try tokenProtected.register(collection: FarmController())
//    try tokenProtected.register(collection: MarkerController())
    
    try app.register(collection: StagesContainerController())
    try app.register(collection: StageController())
    try app.register(collection: OverviewController())
    try app.register(collection: StatusController())
    try app.register(collection: DocumentController())
    try app.register(collection: FilesController())
    try app.register(collection: UserController())
    try app.register(collection: FarmController())
    try app.register(collection: MarkerController())
    try app.register(collection: TeamController())
    
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



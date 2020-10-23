import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req in
        return "It works!"
    }
    
    
    //@gui -> Going to Change Path, using for testing
    app.post("userstates") { (req) -> EventLoopFuture<WSUserState> in
        let create = try req.content.decode(WSUserState.self)
        let state = WSUserState(create.respUserID, create.destTeamID, create.containerID)
        
        return User.find(state.respUserID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (optionalUserState) -> EventLoopFuture<WSUserState> in
                state.name = optionalUserState.name
                state.photo = optionalUserState.name
                return state.save(on: req.db).transform(to: state)
        }
    }
    
    //@gui - > Change to Post for specified with Team
    app.get("userStates",":teamid") { (req) -> EventLoopFuture<[WSUserState]> in
        if let teamID = req.parameters.get("teamid"){
            return WSUserState.query(on: req.db).filter("destTeamID", .equal, UUID(uuidString: teamID)).all()
        }
        return WSUserState.query(on: req.db).all()
    }
    
    let passwordProtected = app.grouped(User.authenticator())
    
    passwordProtected.post("userlogin") { req -> EventLoopFuture<User> in
        let user = try req.auth.require(User.self)
        
        return User.query(on: req.db).filter("id", .equal, user.id).first().flatMapThrowing { (user) in
            return try (user ?? User(name: "", email: "", password: "", isAdmin: false))
        }
    }
    
    //    let tokenProtected = app.grouped(UserToken.authenticator())
    //
    //    tokenProtected.get("me") { req -> User in
    //        try req.auth.require(User.self)
    //    }
    
    
    try app.register(collection: StagesContainerController())
    try app.register(collection: StageController())
    try app.register(collection: OverviewController())
    try app.register(collection: StatusController())
    try app.register(collection: DocumentController())
    try app.register(collection: FilesController())
    try app.register(collection: UserController())
    try app.register(collection: TeamController())
    try app.register(collection: FarmController())
    
}

func webSockets(_ app: Application) throws{
    print("Creating connection")
    
    let dataController = WSInteractor()
    
    /// Aiming to add to a class
    /// Activesession for Web Socket Connection
    
    app.webSocket("UserConnection"){ request,ws in
        var currentUserID: UUID?
        
        ws.onText{ (ws,data) in
            if let dataCov = data.data(using: .utf8){
                guard let message = try? JSONDecoder().decode(WSConnectionPackage.self, from: dataCov) else {return}
                    if let user = WSDataWorker.shared.connections.first(where: {
                        return $0.userState.respUserID == message.newUserState.respUserID
                    }) {
                        currentUserID = user.userState.respUserID
                        dataController.changeStage(userState: user.userState, connection: ws, req: request)
                    } else{
                        message.newUserState.photo = message.newUserState.name
                        dataController.enteredUser(userState: message.newUserState, connection: ws, req: request)
                        currentUserID = message.newUserState.respUserID
                    }
                }
            
        }
        
        
        ws.onClose.whenComplete { result in
            
            try! dataController.signOutUser(userID: currentUserID ?? UUID(),connection: ws,req: request)
            print("Ended Connection")
            // remover usuario
        }
        
    }
    
    
    app.webSocket("DataExchange"){ request,ws in
        
        
        // MARK - Variables
        // Actions for control of User Sessions
        ws.onText { (ws, data) in
            
            
            if let dataCov = data.data(using: .utf8){
                // Make responsability to another class
                guard let message = try? CoderHelper.shared.decodeDataSingle(valueToDecode: dataCov, intendedType: WSDataPackage.self) else {return}
                switch message.operation{
                case 0:
                    // INSERT DATA
                    dataController.addData(sessionRequest: request, data: .init(data: message)) { (response) in
                        switch response.actionStatus{
                        case .Completed:
                            print("Adicionou")
                        case .Error:
                            print()
                        default:
                            print()
                        }
                    }
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
                case 2:
                    // UPDATE DATA
                    dataController.updateData(sessionID: request, dataMessage: .init(data: message)) { (response) in
                        print(response.actionStatus)
                    }
                case 3:
                    // DELETE DATA
                    dataController.deleteData(sessionRequest: request, package: message) { (response) in
                        print(response.actionStatus)
                    }
                default:
                    print()
                    
                    
                }
            }
            
            // Receive the Data from the Client and Decode it
            // Save to DATABASE
            // Must get Team ID,
        }
        
        ws.onBinary { (ws, binary) in
            print(binary)
        }
        
        
        ws.onClose.whenComplete { result in
            print("Ended Connection")
        }
        
        
    }
    
    
}

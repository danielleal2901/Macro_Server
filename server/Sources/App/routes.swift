import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    //let wss = NIOWebSocketServer.default()
    
    app.get { req in
        return "It works!"
    }
    
    // @gui -> Going to Change Path, using for testing
    app.post("userregister") { (req) -> EventLoopFuture<User> in
        let create = try req.content.decode(AuthEntity.self)        
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            name: create.name,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        return user.save(on: req.db)
            .map { user }
    }
    
    let passwordProtected = app.grouped(User.authenticator())
    // @gui -> Going to Change Path, using for testing
    passwordProtected.post("userlogin") { req -> EventLoopFuture<UserToken> in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        
        return token.save(on: req.db)
            .map { token }
    }
    
    let tokenProtected = app.grouped(UserToken.authenticator())
    
    tokenProtected.get("me") { req -> User in
        try req.auth.require(User.self)
    }
    
    
    try app.register(collection: TerrainController())
    try app.register(collection: StageController())
    try app.register(collection: OverviewController())
    try app.register(collection: StatusController())
    
    
}

func webSockets(_ app: Application) throws{
    print("Creating connection")
    
    /// Aiming to add to a class
    /// Active session for Web Socket Connection
    app.webSocket("DataExchange"){ request,ws in
        
        // MARK - Variables
        let dataController = WSInteractor()
        var userID = UUID()
        var teamID = UUID()
        
        
        dataController.enteredUser(userID: userID, teamID: teamID, connection: ws)
        //         dataController.enteredUser(userID: user, teamID: team, connection: ws)
        
        // Actions for control of User Sessions
        ws.onText { (ws, data) in
            if let dataCov = data.data(using: .utf8){
                // Make responsability to another class
                guard let message = CoderHelper.shared.decodeDataSingle(valueToDecode: dataCov, intendedType: WSDataPackage.self) else {return}
                
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
            dataController.signOutUser(userID: userID,connection: ws)        
            print("Ended Connection")
            // remover usuario
        }
        
    }
    
    
}

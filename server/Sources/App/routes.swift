import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    //let wss = NIOWebSocketServer.default()
    
    app.get { req in
        return "It works!"
    }
    
    app.webSocket("echo"){ req,ws in
        print(ws)
    }
    
    app.get("hello") { req -> String in    
        return "Hello, world!"
    }
    
    try app.register(collection: TerrainController())
    try app.register(collection: StageController())
    
    //    try app.register(collection: GeoController())
    //    try app.register(collection: EvaluationController())
    //    try app.register(collection: EnviromentController())
    //    try app.register(collection: ResidentController())
    //    try app.register(collection: RegisterController())
    
}

func webSockets(_ app: Application) throws{
    print("Creating connection")
    
    /// Aiming to add to a class
    /// Active session for Web Socket Connection
    app.webSocket("DataExchange"){ request,ws in
        
        // MARK - Variables
        let dataController = WSInteractor()
        
        // User Info to get via connection Request and register automatically
        //        let user = request.session.data["username"] ?? "User 001"
        //        let team = request.session.data["team"] ?? "Empty Team"
        
        // Add User to Specific Team Session
        //        dataController.enteredUser(userID: user, teamID: team, connection: ws)
        
        
        // Actions for control of User Sessions
        ws.onText { (ws, data) in
            if let dataCov = data.data(using: .ascii){
                // Make responsability to another class
                guard let message = CodableAlias().decodeDataSingle(valueToDecode: dataCov, intendedType: DataMessage.self) else {return}
                switch message.operation{
                case 0:
                    // INSERT DATA
                    dataController.addData(sessionRequest: request, data: .init(data: message)) { (response) in
                        print(response.actionStatus)
                    }
                case 1:
                    // FETCH DATA
                    dataController.fetchData(sessionID: request, dataMessage: .init(data: message)) { (response) in
                        print(response.actionStatus)
                        switch response.actionStatus{
                        case .Completed:
                            let convertedData = String(data: response.dataReceived!,encoding: .utf8)
                            dataController.broadcast(data: convertedData!)
                        case .Error:
                            ws.send("Error")
                        default:
                            ws.send("Error")
                        }
                    }
                case 2:
                    // UPDATE DATA
                    dataController.updateData(sessionID: request, dataMessage: .init(data: message)) { (response) in
                        print(response.actionStatus)
                    }
                case 3:
                    // DELETE DATA                    
                    let data = CodableAlias().decodeDataSingle(valueToDecode: message.data, intendedType: TerrainModel.self)
                    dataController.deleteData(sessionRequest: request, dataID: data!.id ) { (response) in
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
            // remover usuario
        }
        
    }
    
    
}

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
    try app.register(collection: GeoController())
    
}


func webSockets(_ app: Application) throws{
    print("Creating connection")
    
    app.webSocket("DataExchange"){ request,ws in
        
        let dataController = DataController()
        
        let userID = request.session.data["username"] ?? "User 001"
        let teamID = request.session.data["team"] ?? "Empty Team"
        
        //let message = DataMessage(from: )
        
        dataController.enteredUser(userID: userID,teamID: teamID)
        
        
        
        ws.onText { (ws, data) in
            print("Message received")
            print("Client: \(data)")
            
            if let dataCov = data.data(using: .ascii){
                guard let message = try? JSONDecoder().decode(DataMessage.self, from: dataCov) else {return}
                // Data Decoded
                print(message)
                
                dataController.fetchData(sessionID: request, dataMessage: .init(data: message)) { (response) in
                    print(response.actionStatus)
                    switch response.actionStatus{
                    case .Completed:
//                        let byte = [UInt8]((response.dataReceived)!)
//                        let value = String(bytes: byte, encoding: .utf8)
                        let convertedData = String(data: response.dataReceived!,encoding: .utf8)
                        ws.send(convertedData!)
                    case .Error:
                        ws.send("Error")
                    default:
                        ws.send("Error")
                    }
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

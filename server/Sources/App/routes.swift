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
        
        let firstData = request.session.data["firstData"] ?? "First Data nil"
        let secondData = request.session.data["secondData"] ?? "Second Data nil"
        
        dataController.addData(data: .init(data: firstData))
        dataController.addData(data: .init(data: secondData))
        
        
        ws.onText { (ws, data) in            
            //if let receivedData = data.data(using: .utf8),
            //   let decodedData = try? JSONDecoder().decode(SpecifiedData.self, from: receivedData){
            print("Message received")
            print("Client: \(data)")
            
            ws.send("Server sending message back")
            
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

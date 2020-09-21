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
    try app.register(collection: EvaluationController())
    try app.register(collection: EnviromentController())
    try app.register(collection: ResidentController())
    try app.register(collection: RegisterController())


func webSockets(_ app: Application) throws{
    print("Creating connection")
    
    app.webSocket("DataExchange"){ request,ws in
        
        ws.onText { ws, data in
            ws.send("Message Received")
        }
        
        let dataController = DataController()
        
        let firstData = request.session.data["firstData"] ?? "First Data nil"
        let secondData = request.session.data["secondData"] ?? "Second Data nil"
        
        dataController.addData(data: .init(data: firstData))
        dataController.addData(data: .init(data: secondData))
        
        
        ws.onText { (ws, data) in            
            if let receivedData = data.data(using: .utf8),
                let decodedData = try? JSONDecoder().decode(SpecifiedData.self, from: receivedData){
                // Receive the Data from the Client and Decode it
                // Save to DATABASE
                // Must get Team ID,
            }
        }
        
        
        ws.onClose.whenComplete { result in
            print("Ended Connection")
        }
        
    }
    
    
}

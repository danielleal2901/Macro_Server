import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    //let wss = NIOWebSocketServer.default()
    
    app.get { req in
        return "It works!"
    }

    app.webSocket("echo2"){ req,ws in
        print(ws)
    }

    app.get("hello") { req -> String in
        NetworkManager().connect(url: URL.init(string:"localhost:8080/terrains")!)
        return "Hello, world!"
    }
    
    app.post("WebSocketTesting"){req -> String in
        print("Received")
        let data = try req.content.decode(InfoData.self)
        return "hello \(data.dataString)"
        
    }
    try app.register(collection: TerrainController())
    try app.register(collection: GeoController())
 
}


func webSockets(_ app: Application) throws{
    print("Creating connection")
    
    app.webSocket("echo"){ request,ws in
        ws.onText { ws, texto in
            print(texto)
            ws.send("Message")
        }
        
        ws.onClose.whenComplete { result in
            print("ended")
        }
    }
}

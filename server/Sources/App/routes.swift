import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req in
        return "It works!"
    }


    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.post("WebSocketTesting"){req -> String in
        NetworkManager().connect(url: URL.init(string:"localhost:8080/terrains")!)        
        print("Received")
        let data = try req.content.decode(InfoData.self)
        return "hello \(data.dataString)"
        
    }
    try app.register(collection: TerrainController())

}

import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.post("receivePost"){req -> String in
        NetworkManager().connect()
        print("Received")
        let data = try req.content.decode(InfoData.self)
        return "hello \(data.name)"
        
    }

    try app.register(collection: TodoController())
}

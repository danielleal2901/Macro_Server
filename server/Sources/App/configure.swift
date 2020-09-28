import Fluent
import FluentPostgresDriver
import Vapor
import NIOWebSocket
import NIOHTTP2


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: "localhost",
        username: "postgres",
        password: "",
        database: "macro_challenge_dev"), as: .psql)
    
    app.http.server.configuration.hostname = "127.0.0.1"    
    app.http.server.configuration.port = 8080
    
    app.migrations.add(CreateTerrain())
    
    app.middleware.use(app.sessions.middleware)
    app.sessions.use(.memory)
    
    app.migrations.add(CreateStage())
    app.migrations.add(CreateDocument())
    app.migrations.add(CreateOverview())
    app.migrations.add(CreateStatus())
    app.migrations.add(CreateUser())
//    app.migrations.add(CreateEnum())

    // register routes
    try routes(app)
    try webSockets(app)
    
}


import Fluent
import FluentPostgresDriver
import Vapor
import NIOWebSocket
import NIOHTTP2
import Mailgun


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
        
    app.middleware.use(app.sessions.middleware)
    app.sessions.use(.memory)
    
    // Mailer
//    app.mailgun.configuration = .environment
    app.mailgun.configuration = .init(apiKey: "2b7a87ba6bae7abe21d5fe1e1faf56ad-ea44b6dc-cd9d4697")
    app.mailgun.defaultDomain = .mainDomain
        
    //Enums: should be called first
    app.migrations.add(CreateStageTypesEnum())
    app.migrations.add(CreateStagesContainersTypesEnum())

//
    app.migrations.add(CreateTeam())
    app.migrations.add(CreateFarm())
    app.migrations.add(CreateStagesContainer())
    app.migrations.add(CreateStage())
    app.migrations.add(CreateDocument())
    app.migrations.add(CreateOverview())
    app.migrations.add(CreateStatus())
    app.migrations.add(CreateFiles())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
//    app.migrations.add(CreateUserState())


    // register routes
    try routes(app)
    try webSockets(app)
    
}


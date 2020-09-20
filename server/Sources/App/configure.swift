import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: "localhost",
        username: "postgres",
        password: "",
        database: "macro_challenge_dev"), as: .psql)

    app.migrations.add(CreateTerrain())
    app.migrations.add(CreateStage())
//    app.migrations.add(CreateGeoreferecing())

    // register routes
    try routes(app)
}

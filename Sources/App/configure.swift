import Vapor

public func configure(_ app: Application) throws {
    // Hostname: in Docker must be 0.0.0.0
    if let host = Environment.get("HOSTNAME") {
        app.http.server.configuration.hostname = host
    } else {
        app.http.server.configuration.hostname = "0.0.0.0"
    }

    // Port environment varialbe
    if let portEnv = Environment.get("PORT"), let port = Int(portEnv) {
        app.http.server.configuration.port = port
    } else {
        app.http.server.configuration.port = 8080
    }

    // Routes
    try routes(app)
}
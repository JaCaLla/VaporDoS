import Vapor
import Redis

public func configure(_ app: Application) throws {
    // Config servidor (para Docker)
    let hostname = Environment.get("HOSTNAME") ?? "0.0.0.0"
    app.http.server.configuration.hostname = hostname

    if let portEnv = Environment.get("PORT"), let port = Int(portEnv) {
        app.http.server.configuration.port = port
    } else {
        app.http.server.configuration.port = 8080
    }

    // Config Redis
    let redisHostname = Environment.get("REDIS_HOST") ?? "redis"
    let redisPort = Environment.get("REDIS_PORT").flatMap(Int.init) ?? 6379

    app.redis.configuration = try .init(
        hostname: redisHostname,
        port: redisPort
    )

    // Middleware de rate limit
    app.middleware.use(RateLimitMiddleware())

    // Rutas
    try routes(app)
}

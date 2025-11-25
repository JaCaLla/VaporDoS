import Vapor
import Redis

struct RateLimitMiddleware: AsyncMiddleware {

    // Maximum 2 request every 30 secs
    private let maxRequests = 2
    private let windowSeconds = 30

    func respond(
        to request: Request,
        chainingTo next: AsyncResponder
    ) async throws -> Response {

        // Only apply to /hello service
        guard request.url.path == "/hello" else {
            return try await next.respond(to: request)
        }

        let ip = request.remoteAddress?.ipAddress ?? "unknown"
        let key = "rate:\(ip)"

        // INCR key
        let incrResponse = try await request.redis.send(
            command: "INCR",
            with: [RESPValue(from: key)]
        )

        let newCount = incrResponse.int ?? 0

        // When is first time, we set window expiration
        if newCount == 1 {
            _ = try await request.redis.send(
                command: "EXPIRE",
                with: [
                    RESPValue(from: key),
                    RESPValue(from: windowSeconds)
                ]
            )
        }

        // Limit overpassed
        if newCount > maxRequests {
            throw Abort(
                .tooManyRequests,
                reason: "You exeded the limit of 2 request every 30 secs on /hello endpoint."
            )
        }

        return try await next.respond(to: request)
    }
}

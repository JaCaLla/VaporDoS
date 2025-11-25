import Vapor

func routes(_ app: Application) throws {
    app.get("hello") { req -> String in
        return "Hello from Vapor inside Docker 👋"
    }

    app.get { req -> String in
        "Service OK"
    }
}
import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auths = routes.grouped("auth")
		auths.post("google/login", use: {
			try await self.loginWithGoogle(req: $0)
		})
    }

	func loginWithGoogle(req: Request) async throws -> User {
		logger.info("Received new request at 'auth/google/login'")
		let loginRequest = try req.content.decode(LoginRequest.self, as: .json)
		let user = User()
		user.oidcToken = loginRequest.idToken
		user.oidcProvider = .google
		try await user.save(on: req.db)
		logger.info("user is saved: \(user)")
		return user
	}
}

extension AuthController {
	struct LoginRequest: Codable {
		let idToken: String
		let expirationDate: Double
	}
}

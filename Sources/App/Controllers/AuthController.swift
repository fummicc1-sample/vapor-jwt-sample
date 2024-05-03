import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
		let auths = routes.grouped("auth").grouped("google")
		auths.post("login") { req in
			print("hello, req:", req)
			return try await self.loginWithGoogle(req: req)
		}
    }

	func loginWithGoogle(req: Request) async throws -> User {
		logger.info("Received new request at 'auth/google/login'")
		let loginRequest = try req.content.decode(LoginRequest.self, as: .json)
		if let existingUser = try await User.query(on: req.db).filter(\User.$email == loginRequest.email).first() {
			print("existingUser", existingUser)
			return existingUser
		}
		let user = User()
		user.id = .init()
		user.oidcToken = loginRequest.idToken
		user.oidcProvider = .google
		user.email = loginRequest.email
		try await user.save(on: req.db(.sqlite))
		logger.info("user is saved: \(user)")
		return user
	}
}

extension AuthController {
	struct LoginRequest: Codable {
		let idToken: String
		let expirationDate: Double
		let email: String
	}
}

import Fluent
import Vapor
import JWTKit

enum AuthError: LocalizedError {
	case expiredIdToken(expirationDate: Date)
}

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
		let auths = routes.grouped("auth").grouped("google")
		auths.post("login") { req in
			print("hello, req:", req)
			return try await self.loginWithGoogle(req: req)
		}
    }

	func loginWithGoogle(req: Request) async throws -> LogInResponse {
		req.logger.info("[auth/google/login] Received new request.")
		let loginRequest = try req.content.decode(LoginRequest.self, as: .json)

		try validateOidcToken(
			exp: Date(
				timeIntervalSince1970: loginRequest.oidcTokenExpirationDate
			)
		)

		if let existingUser = try await User.query(on: req.db).filter(\User.$email == loginRequest.email).first(), let userId = existingUser.id {
			req.logger.info("existingUser: \(existingUser)")
			let token = try await makeToken(userId: userId)
			return .init(
				user: existingUser,
				accessToken: token
			)
		}
		let user = User()
		let userId = UUID()
		user.id = userId
		user.oidcProvider = .google
		user.email = loginRequest.email
		try await user.save(on: req.db(.sqlite))
		req.logger.info("created user: \(user)")
		let token = try await makeToken(userId: userId)
		return .init(
			user: user,
			accessToken: token
		)
	}

	private func makeToken(userId: UUID) async throws -> String {
		let payload = UserTokenPayload.make(
			userId: userId,
			expDays: 1
		)
		let tokenizer = try await AuthTokenizer()
		let token = try await tokenizer.sign(payload: payload)
		return token
	}

	private func validateOidcToken(exp: Date) throws {
		let now = Date()
		switch exp.compare(now) {
		case .orderedDescending:
			return
		case .orderedAscending, .orderedSame:
			throw AuthError.expiredIdToken(expirationDate: exp)
		}
	}
}

extension AuthController {
	struct LoginRequest: Codable {
		let idToken: String
		let oidcTokenExpirationDate: Double
		let email: String
	}

	struct LogInResponse: Content {
		let user: User
		let accessToken: String
	}
}

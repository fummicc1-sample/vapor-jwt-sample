@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }

	func test_loginWithGoogle() async throws {
		let app = Application(.testing)

		defer { app.shutdown() }
		try await configure(app)

		let request = AuthController.LoginRequest(
			idToken: "test",
			oidcTokenExpirationDate: Date().addingTimeInterval(3600).timeIntervalSince1970,
			email: "test@gmail.com"
		)
		let requestData = try JSONEncoder().encode(request)
		let buffer = ByteBuffer(data: requestData)

		try app.test(.POST, "auth/google/login", body: buffer) { response in
			let responseModel = try JSONDecoder().decode(
				AuthController.LogInResponse.self,
				from: response.body
			)
			let user = responseModel.user
			XCTAssertEqual(user.email, request.email)
			XCTAssertEqual(user.oidcProvider, OidcProvider.google)
		}
	}
}

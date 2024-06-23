//
//  UserService.swift
//  VaporGoogleAuthClient
//
//  Created by Fumiya Tanaka on 2024/04/27.
//

import Foundation
import GoogleSignIn

public struct UserService {
	let session: URLSession

	public init(session: URLSession = .shared) {
		self.session = session
	}

	public func login(with user: GIDGoogleUser) async throws -> User? {
		guard let idToken = user.idToken?.tokenString else {
			throw Error.idTokenNotFound(user: user)
		}
		guard let expiration = user.idToken?.expirationDate else {
			return nil
		}
		let url = URL(string: "http://localhost:8080/auth/google/login")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = try JSONEncoder().encode(
			LoginRequest(
				idToken: idToken,
				oidcTokenExpirationDate: expiration.timeIntervalSince1970,
				email: user.profile?.email ?? ""
			)
		)
		let (data, _) = try await session.data(for: request)
		let decoder = JSONDecoder()
		let response = try decoder.decode(
			LogInResponse.self,
			from: data
		)
		let user = response.user
		return user
	}
}

extension UserService {
	public enum Error: LocalizedError {
		case idTokenNotFound(user: GIDGoogleUser)
	}

	public struct LoginRequest: Codable {
		let idToken: String
		let oidcTokenExpirationDate: Double
		let email: String
	}

	public struct LogInResponse: Codable {
		let user: User
		let accessToken: String
	}
}

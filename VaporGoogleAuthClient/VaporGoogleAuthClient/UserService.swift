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

	public func login(with user: GIDGoogleUser) async throws {
		guard let idToken = user.idToken?.tokenString else {
			throw Error.idTokenNotFound(user: user)
		}
		guard let expiration = user.idToken?.expirationDate else {
			return
		}
		let url = URL(string: "http://localhost:8080/auth/google/login")!
		var request = URLRequest(url: url)
		request.httpBody = try JSONSerialization.data(withJSONObject: [
			"idToken": idToken,
			"expirationDate": expiration.timeIntervalSince1970
		])
		session.dataTask(with: request)
	}
}

extension UserService {
	public enum Error: LocalizedError {
		case idTokenNotFound(user: GIDGoogleUser)
	}
}

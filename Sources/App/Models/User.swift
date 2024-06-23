//
//  User.swift
//
//
//  Created by Fumiya Tanaka on 2024/04/28.
//

import Foundation
import Fluent
import Vapor

final class User: Model, Content {
	public static let schema: String = "users"

	@ID(custom: .id)
	var id: UUID?

	@Field(key: .string("oidc_provider"))
	var oidcProvider: OidcProvider?
	@Field(key: "email")
	var email: String
}

public enum OidcProvider: String, Codable, Sendable {
	case google
}

import JWTKit

struct UserTokenPayload: JWTPayload {
	func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
		try exp.verifyNotExpired()
	}

	let userId: UUID
	let exp: ExpirationClaim
	let iat: IssuedAtClaim

	static func make(userId: UUID, expDays: Int) -> UserTokenPayload {
		let calender = Calendar(identifier: .gregorian)
		guard let exp = calender.date(byAdding: DateComponents(day: 30), to: Date()) else {
			fatalError("Failed to create expirationClaim")
		}
		return .init(
			userId: userId,
			exp: .init(value: exp),
			iat: .init(
				value: Date()
			)
		)
	}
}

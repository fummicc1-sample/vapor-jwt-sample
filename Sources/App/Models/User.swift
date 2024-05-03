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

	@ID(key: .id)
	var id: UUID?

	@Field(key: .string("oidc_token"))
	var oidcToken: String?
	@Field(key: .string("oidc_provider"))
	var oidcProvider: OidcProvider?
	@Field(key: "email")
	var email: String?
}

public enum OidcProvider: String, Codable, Sendable {
	case google
}

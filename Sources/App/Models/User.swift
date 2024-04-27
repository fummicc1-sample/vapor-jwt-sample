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

	var oidcToken: String?
	var oidcProvider: OidcProvider?
	var email: String?
}

public enum OidcProvider: String, Codable {
	case google
}

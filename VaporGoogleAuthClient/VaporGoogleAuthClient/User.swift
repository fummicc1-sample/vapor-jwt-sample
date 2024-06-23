import Foundation

public struct User: Codable, Sendable {
	var id: String?

	var oidcProvider: OidcProvider?

	var email: String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case oidcProvider = "oidcProvider"
		case email = "email"
	}
}


public enum OidcProvider: String, Codable, Sendable {
	case google

	var name: String {
		switch self {
		case .google:
			"Googleでログイン済み"
		}
	}
}

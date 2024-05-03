import Foundation

@Observable
public class User: Codable {
	var id: String?

	var oidcToken: String?

	var oidcProvider: OidcProvider?

	var email: String?

	enum CodingKeys: String, CodingKey {
		case _id = "id"
		case _oidcToken = "oidcToken"
		case _oidcProvider = "oidcProvider"
		case _email = "email"
	}
}


public enum OidcProvider: String, Codable, Sendable {
	case google
}

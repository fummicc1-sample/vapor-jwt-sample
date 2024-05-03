import Fluent

struct CreateUser: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema("users")
			.id()
			.field("oidc_provider", .string)
			.field("oidc_token", .string)
			.field("email", .string)
			.create()
	}

	func revert(on database: Database) async throws {
		try await database.schema("users").delete()
	}
}

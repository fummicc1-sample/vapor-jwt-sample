//
//  AuthTokenizer.swift
//
//
//  Created by Fumiya Tanaka on 2024/06/23.
//

import Foundation
import JWTKit

public actor AuthTokenizer {
	let keys: JWTKeyCollection = .init()

	public init() async throws {
		try await addPrivateKey()
	}

	func addPrivateKey() async throws {
		try await keys.add(
			eddsa: EdDSA.PrivateKey(),
			kid: "secret-key"
		)
	}

	public func sign(payload: some JWTPayload) async throws -> String {
		try await keys.sign(payload, kid: "secret-key")

	}
}

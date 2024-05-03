//
//  ContentView.swift
//  VaporGoogleAuthClient
//
//  Created by Fumiya Tanaka on 2024/04/27.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {

	@State private var user: User?

	var body: some View {
		VStack {
			if let user {
				let _ = print(user.email)
				HStack {
					Text(user.email ?? "")
						.font(.title)
					Text(user.oidcToken ?? "")
						.font(.title3)
				}
				.padding()
			} else {
				GoogleSignInButton {
					guard let windowScene = UIApplication.shared.connectedScenes.first(where: {
						$0.activationState == .foregroundActive
					}) as? UIWindowScene, let rootViewController = windowScene.keyWindow?.rootViewController else {
						fatalError()
					}
					Task {
						do {
							let result = try await GIDSignIn.sharedInstance.signIn(
								withPresenting: rootViewController
							)
							let idToken = result.user.idToken
							logger.debug("idToken: \(idToken)")
							user = try await userService.login(with: result.user)
							print(user)
						} catch {
							logger.error("\(error)")
						}
					}
				}
				.padding()
			}
		}
	}
}

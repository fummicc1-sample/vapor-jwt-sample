//
//  ContentView.swift
//  VaporGoogleAuthClient
//
//  Created by Fumiya Tanaka on 2024/04/27.
//

import Atoms
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct ContentView: View {

	@WatchState(UserAtom())
	var user

	var body: some View {
		VStack(alignment: .leading) {
			if let user {
				Text("Logged In")
					.font(.largeTitle)
				Text(user.email ?? "")
					.font(.title)
				HStack {
					Spacer()
					Text(user.oidcProvider?.name ?? "")
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
		.padding()
		.onOpenURL { url in
			GIDSignIn.sharedInstance.handle(url)
		}
		.task {
			do {
				let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
				logger.info("\(user)")
				self.user = try await userService.login(
					with: user
				)
			} catch {
				logger.error("\(error)")
			}
		}
	}
}

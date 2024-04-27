//
//  VaporGoogleAuthClientApp.swift
//  VaporGoogleAuthClient
//
//  Created by Fumiya Tanaka on 2024/04/27.
//

import SwiftUI
import GoogleSignIn
import OSLog

let logger = Logger(subsystem: "dev.fummicc1.VaporGoogleAuthClient", category: "")
let userService = UserService()

@main
struct VaporGoogleAuthClientApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
				.onOpenURL { url in
					GIDSignIn.sharedInstance.handle(url)
				}
				.task {
					do {
						let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
						logger.info("\(user)")
						try await userService.login(with: user)
					} catch {
						logger.error("\(error)")
					}
				}
        }
    }
}

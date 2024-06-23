//
//  VaporGoogleAuthClientApp.swift
//  VaporGoogleAuthClient
//
//  Created by Fumiya Tanaka on 2024/04/27.
//

import Atoms
import SwiftUI
import GoogleSignIn
import OSLog

let logger = Logger(subsystem: "dev.fummicc1.VaporGoogleAuthClient", category: "")
let userService = UserService()

@main
struct VaporGoogleAuthClientApp: App {

    var body: some Scene {
        WindowGroup {
			AtomRoot {
				ContentView()
			}
        }
    }
}

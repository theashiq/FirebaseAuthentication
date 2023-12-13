//
//  FirebaseAuthenticationApp.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import SwiftUI
import FirebaseCore

@main
struct FirebaseAuthenticationApp: App {
    
    @StateObject var authTracker = AuthTracker(authProvider: DummyAuthProvider())

    init() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authTracker)
        }
    }
}

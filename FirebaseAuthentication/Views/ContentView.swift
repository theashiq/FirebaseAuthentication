//
//  ContentView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authTracker: AuthTracker
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            if authTracker.isAuthenticated{
                Text("Hello, \(authTracker.displayName)!")
                Button("Logout") {
                    withAnimation {
                        authTracker.authProvider.logout(handler: nil)
                    }
                }
            }
            else{
                Text("Hello, world!")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthTracker(authProvider: DummyAuthProvider()))
}

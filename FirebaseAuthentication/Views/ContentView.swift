//
//  ContentView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authTracker: AuthTracker
    @State var showAuthView: Bool = false
    let someColors: [Color] = [.red, .green, .blue]
    let moreColors: [Color] = [.cyan, .teal, .orange, .brown, .gray]
    
    var body: some View {
        
        ZStack{
            VStack {
                Text("Hello, \(authTracker.displayName)!")
                    .isHidden(!authTracker.isAuthenticated, remove: true)
                    .padding(.vertical)
                
                HStack{
                    ForEach(someColors, id: \.self){ color in
                        color.clipShape(.circle)
                            .frame(width: 50, height: 50)
                    }
                }
                
                HStack{
                    ForEach(moreColors, id: \.self){ color in
                        color.clipShape(.circle)
                            .frame(width: 50, height: 50)
                    }
                }
                .isHidden(!authTracker.isAuthenticated, remove: true)
                
                
                Button("Login for More Colors") {
                    withAnimation {
                        showAuthView.toggle()
                    }
                }
                .padding(.vertical)
                .isHidden(authTracker.isAuthenticated, remove: true)
                
                Button("Logout") {
                    withAnimation {
                        authTracker.authProvider.logout{ _ in
                            showAuthView = false
                        }
                    }
                }
                .isHidden(!authTracker.isAuthenticated, remove: true)
            }
            .padding()
            
            AuthenticationView(viewModel: AuthenticationViewModel(authProvider: authTracker.authProvider))
                .isHidden(!showAuthView, remove: true)
        }
        .onChange(of: authTracker.isAuthenticated){ value in
            if value{
                showAuthView = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthTracker(authProvider: DummyAuthProvider()))
}

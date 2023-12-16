//
//  AuthenticationView.swift
//  RockPaperScissorsFight
//
//  Created by mac 2019 on 12/2/23.
//

import SwiftUI

struct AuthenticationView: View{
    
    @EnvironmentObject var authTracker: AuthTracker
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        
        ZStack{
            
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                
                LogoView()
                    .scaleEffect(0.75, anchor: UnitPoint(x: 0.5, y: 0))
                    .padding(.bottom)
                
                if viewModel.isEmailAuthAvailable{
                    EmailAuthenticationView(viewModel: EmailAuthenticationViewModel(emailAuthProvider: authTracker.authProvider as! EmailAuthProvider))
                        .padding(.bottom)
                    Spacer()
                }
                if viewModel.isPhoneAuthAvailable{
                    PhoneAuthenticationView(viewModel: PhoneAuthenticationViewModel(phoneAuthProvider: authTracker.authProvider as! PhoneAuthProvider))
                        .padding(.bottom)
                    Spacer()
                }
                if viewModel.isSocialAuthAvailable{
                    Spacer()
                    hDivider
                    Text("Use a Social Login")
                        .foregroundStyle(Color(.secondaryLabel))
                    
                    SocialAuthenticationView(viewModel: SocialAuthenticationViewModel(socialAuthProvider: viewModel.authProvider as! SocialAuthProvider))
                        .padding(.bottom)
                }
                
                if viewModel.isAnonymousAuthAvailable{
                    AnonymousAuthenticationView(viewModel: AnonymousAuthenticationViewModel(anonymousAuthProvider: viewModel.authProvider as! AnonymousAuthProvider))
                        .padding(.bottom)
                }
                
                Button("Logout") {
                    withAnimation {
                        authTracker.authProvider.logout(handler: nil)
                    }
                }
                .isHidden(!authTracker.isAuthenticated, remove: true)
                
            }
        }
        .frame(maxWidth: 400)
        .padding()
        .alert(viewModel.alert.title,
            isPresented: $viewModel.isAlertPresented,
            actions: { Button("OK", action: viewModel.dismissAlert) },
            message: { Text(viewModel.alert.message) }
        )
    }
    
    private var hDivider: some View{
        HStack{
            Rectangle().frame(height: 2).frame(maxWidth: 50)
            Text("Or")
            Rectangle().frame(height: 2).frame(maxWidth: 50)
        }
        .bold()
        .foregroundStyle(.gray)
        .padding(.vertical)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var authTracker: AuthTracker = AuthTracker(authProvider: DummyAuthProvider())
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel(authProvider: authTracker.authProvider))
            .environmentObject(authTracker)
    }
}



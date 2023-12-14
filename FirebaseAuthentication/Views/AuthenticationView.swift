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
        
        VStack {
            
            LogoView()
                .scaleEffect(0.75, anchor: UnitPoint(x: 0.5, y: 0))
                .padding(.bottom)
            
            Spacer()
            
            if viewModel.isEmailAuthAvailable{
                Text("Email Authentication View Goes Here")
                Spacer()
            }
            if viewModel.isPhoneAuthAvailable{
                Text("Phone Authentication View Goes Here")
                Spacer()
            }
            
            anonymousLogin
                .disabled(viewModel.inProgress)
                .isHidden(!viewModel.isAnonymousAuthAvailable, remove: true)
            
        }
        .padding()
        .frame(maxWidth: 200)
        .inProgress(viewModel.inProgress, progressText: viewModel.progressMessage)
        .alert(viewModel.alert.title, 
               isPresented: $viewModel.isAlertPresented,
               actions: { Button("OK", action: viewModel.dismissAlert) },
               message: { Text(viewModel.alert.message) }
        )
    }
    
    private func colorForSocialButton(socialOption: SocialAuthOption) -> Color{
        switch socialOption {
        case .apple:
                return Color.gray
        case .google:
                return Color.blue
        }
    }
    
    private var anonymousLogin: some View{
        Button{
            withAnimation{
                viewModel.loginAnonymously()
            }
        } label: {
            Text("Login as Guest")
                .foregroundStyle(Color.accentColor)
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var authTracker: AuthTracker = AuthTracker(authProvider: DummyAuthProvider())
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel(authProvider: authTracker.authProvider))
            .environmentObject(authTracker)
    }
}



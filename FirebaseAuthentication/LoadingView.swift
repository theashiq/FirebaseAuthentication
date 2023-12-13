//
//  LoadingView.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//


import SwiftUI


struct LoadingView: View{
    
    @EnvironmentObject var authTracker: AuthTracker
    @State private var logoViewTime = 2
    @State private var isShowingLogo = true
    
    var body: some View{
        ZStack{
            
            if authTracker.isAuthenticated{
                ContentView()
            }
            else{
                Text("Go to login/register")
            }
            
            if isShowingLogo{
                Color(.systemBackground)
                    .ignoresSafeArea()
                loadingView
                    .task {
                        countDown()
                    }
            }
        }
    }
    
    func countDown(){
        if logoViewTime <= 0{
            isShowingLogo = false
        }
        else{
            logoViewTime -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                countDown()
            }
        }
        
    }
    
    private var loadingView: some View{
        
        VStack{
            
            Spacer()
            
            LogoView()
                .frame(height: 100)
            
            Spacer()
            
            VStack{
                ProgressView()
                Text("Loading")
            }
            .padding(.bottom, 50)
        }
        
    }
}

#Preview {
    LoadingView()
        .environmentObject(AuthTracker(authProvider: DummyAuthProvider()))
}

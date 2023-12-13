//
//  DummyAuthProvider.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import Foundation

class DummyAuthProvider: AuthProvider{
    
    private var isLoading = false
    private let delay: DispatchTimeInterval = DispatchTimeInterval.seconds(1)
    private var user: AuthUser? = nil{
        didSet{
            authUserUpdateDelegate?.authUserDidChange(authUser: user)
        }
    }
    
    init(){
        // Calling this function just to simulate session retention
        loginAnonymously()
    }
    
    var authUserUpdateDelegate: AuthUserUpdateDelegate?
    
    // MARK: AuthProvider Delegates
    func loginAnonymously(handler: AuthResponseHandler? = nil) {
        
        guard user == nil else{
            handler?(.alreadyLoggedIn)
            return
        }
        guard !isLoading else{
            handler?(.loading)
            return
        }
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            
            var error: AuthError? = nil
            if Int.random(in: 0...1) == 1{
                let userId = UUID().uuidString
                let userDisplayName = "Anonymous User \(userId.suffix(3))"
                self.user = AuthUser(id: userId, displayName: userDisplayName)
            }
            else{
                error = .loginFail
            }
            self.isLoading = false
            handler?(error)
        }
    }
    
    func logout(handler: AuthResponseHandler? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            self.user = nil
            handler?(nil)
        }
    }
    
}

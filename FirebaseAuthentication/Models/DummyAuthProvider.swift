//
//  DummyAuthProvider.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import Foundation

class DummyAuthProvider: AuthProvider, AnonymousAuthProvider{
    private let key_SavedLoginUser: String = "SavedLoginUser"
    private var inProgress = false
    private let delay: DispatchTimeInterval = DispatchTimeInterval.seconds(1)
    private var user: AuthUser? = nil{
        didSet{
            authUserUpdateDelegate?.authUserDidChange(authUser: user)
        }
    }
    
    init(){
        retainExistingUser()
    }
    
    var authUserUpdateDelegate: AuthUserUpdateDelegate?
    
    // MARK: AuthProvider Delegates
    func retainExistingUser(handler: AuthResponseHandler? = nil) {
        
        guard user == nil else{
            handler?(.alreadyLoggedIn)
            return
        }
        guard !inProgress else{
            handler?(.loading)
            return
        }
        
        inProgress = true
        
        let jsonDecoder = JSONDecoder()
        
        if let savedUserData = UserDefaults.standard.data(forKey: key_SavedLoginUser),
           let existingUser = try? jsonDecoder.decode(AuthUser.self, from: savedUserData){
            self.user = existingUser
        }
        
        self.inProgress = false
        handler?(nil)
    }
    
    func logout(handler: AuthResponseHandler? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            UserDefaults.standard.removeObject(forKey: self.key_SavedLoginUser)
            self.user = nil
            handler?(nil)
        }
    }

    // MARK: AnonymousAuthProvider Delegates
    func loginAnonymously(handler: AuthResponseHandler? = nil) {
        
        guard user == nil else{
            handler?(.alreadyLoggedIn)
            return
        }
        guard !inProgress else{
            handler?(.loading)
            return
        }
        
        inProgress = true
        
        let userId = UUID().uuidString
        let userDisplayName = "AnonymousUser_\(userId.suffix(3))"
        let user = AuthUser(id: userId, displayName: userDisplayName)
        var error: AuthError? = nil
        
        let jsonEncoder = JSONEncoder()
        if let userData = try? jsonEncoder.encode(self.user){
            UserDefaults.standard.set(userData, forKey: key_SavedLoginUser)
        }
        else{
            error = .loginFail
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            self.user = user
            self.inProgress = false
            handler?(error)
        }
    }
}

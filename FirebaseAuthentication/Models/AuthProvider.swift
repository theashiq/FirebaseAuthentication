//
//  AuthProvider.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import Foundation

typealias AuthResponseHandler = (AuthError?) -> Void

// MARK: AuthProvider
protocol AuthProvider {
    var authUserUpdateDelegate: AuthUserUpdateDelegate? { get set }
    func loginAnonymous(handler: AuthResponseHandler?)
    func logout(handler: AuthResponseHandler?)
}

// MARK: EmailAuthProvider
protocol EmailAuthProvider: AuthProvider{
    func emailPassRegister(displayName: String, email: String, password: String, handler: AuthResponseHandler?)
    func emailPassLogin(email: String, password: String, handler: AuthResponseHandler?)
    func resetPassword(email: String, handler: AuthResponseHandler?)
}

// MARK: SocialAuthProvider
enum SocialAuthOption { case google, apple }

extension SocialAuthOption{
    var name: String{
        switch self{
        case .apple: "Apple"
        case .google: "Google"
        }
    }
}
protocol SocialAuthProvider: AuthProvider{
    var supportedSocialOptions: Set<SocialAuthOption> {get}
    func socialLogin(option: SocialAuthOption, handler: AuthResponseHandler?)
}

// MARK: PhoneAuthProvider
protocol PhoneAuthProvider: AuthProvider{
    func phoneRegister(phone: String, handler: AuthResponseHandler?)
    func verifyPhoneNumber(code: String, handler: AuthResponseHandler?)
}

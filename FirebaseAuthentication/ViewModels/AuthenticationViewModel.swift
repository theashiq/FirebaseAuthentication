//
//  AuthenticationViewModel.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import FirebaseAuth

class AlerterViewModel: ObservableObject{
    
    @Published var isAlertPresented: Bool = false
    @Published var alert: AlertMe = .none{
        didSet{
            if alert != .none{
                isAlertPresented = true
            }
        }
    }
    
    func dismissAlert(){
        self.alert = .none
    }
}

class AuthenticationViewModel: AlerterViewModel{
    
    private(set) var authProvider: AuthProvider
    
    @Published private(set) var inProgress: Bool = false
    @Published private(set) var isAnonymousAuthAvailable: Bool = false
    @Published private(set) var isEmailAuthAvailable: Bool = false
    @Published private(set) var isPhoneAuthAvailable: Bool = false
    @Published private(set) var isSocialAuthAvailable: Bool = false
    @Published private(set) var socialAuthOptions: [SocialAuthOption] = []
    
    init(authProvider: AuthProvider){
        self.authProvider = authProvider
        self.isAnonymousAuthAvailable = authProvider is AnonymousAuthProvider
        self.isEmailAuthAvailable = authProvider is EmailAuthProvider
        self.isPhoneAuthAvailable = authProvider is PhoneAuthProvider
        self.isSocialAuthAvailable = authProvider is SocialAuthProvider
        self.socialAuthOptions = (authProvider as? SocialAuthProvider)?.supportedSocialOptions.filter{ _ in true} ?? []
    }
}

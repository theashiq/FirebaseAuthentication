//
//  AuthenticationViewModel.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import FirebaseAuth


class AuthenticationViewModel: ObservableObject{
    
    private(set) var authProvider: AuthProvider
    
    @Published private(set) var inProgress: Bool = false
    @Published private(set) var progressMessage: String = ""
    @Published private(set) var alert: AlertMe = .none{
        didSet{
            if alert != .none{
                isAlertPresented = true
            }
        }
    }
    @Published var isAlertPresented: Bool = false
    
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
        self.socialAuthOptions = (authProvider as? SocialAuthProvider)?.supportedSocialOptions.filter({ _ in true
        }) ?? []
    }
    
    private func setProgressState(_ inProgress: Bool, message: String = ""){
        self.inProgress = inProgress
        self.progressMessage = inProgress ? message : ""
    }
    
    // MARK: - User Intents
    
    func dismissAlert(){
        self.alert = .none
    }
    
    func loginAnonymously(){
        guard !inProgress else { return }
        guard let anonymousAuthProvider = (authProvider as? AnonymousAuthProvider) else { return }
        
        setProgressState(true, message: "Logging In")
        
        anonymousAuthProvider.loginAnonymously {[weak self] authError in
            DispatchQueue.main.async{
                if let authError{
                    self?.alert = .authErrorAlert(from: authError)
                }
                self?.setProgressState(false)
            }
        }
    }
}

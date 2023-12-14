//
//  AuthenticationViewModel.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/13/23.
//

import FirebaseAuth

enum AlertMe: Equatable{
    case none
    case alert(AuthError)
    case text(String, String)
    
    var title: String{
        switch self{
        case .none: return ""
        case .alert(let authError): return authError.rawValue
        case .text(let title, _): return title
        }
    }
    var message: String{
        switch self{
        case .none: return ""
        case .alert(let authError): return authError.errorDescription ?? ""
        case .text(_, let message): return message
        }
    }
}

class AuthenticationViewModel: ObservableObject{
    
    private(set) var authProvider: AuthProvider
    
    @Published private(set) var inProgress: Bool = false
    @Published private(set) var isAnonymousAuthAvailable: Bool = false
    @Published private(set) var isEmailAuthAvailable: Bool = false
    @Published private(set) var isPhoneAuthAvailable: Bool = false
    @Published private(set) var isSocialAuthAvailable: Bool = false
    @Published private(set) var socialAuthOptions: [SocialAuthOption] = []
    
    @Published var isAlertPresented: Bool = false
    @Published var alert: AlertMe = .none{
        didSet{
            if alert != .none{
                isAlertPresented = true
            }
        }
    }

    init(authProvider: AuthProvider){
        self.authProvider = authProvider
        self.isAnonymousAuthAvailable = authProvider is AnonymousAuthProvider
        self.isEmailAuthAvailable = authProvider is EmailAuthProvider
        self.isPhoneAuthAvailable = authProvider is PhoneAuthProvider
        self.isSocialAuthAvailable = authProvider is SocialAuthProvider
        self.socialAuthOptions = (authProvider as? SocialAuthProvider)?.supportedSocialOptions.filter({ _ in true
        }) ?? []
    }
    
    func loginAnonymously(){
        guard !inProgress else { return }
        guard let anonymousAuthProvider = (authProvider as? AnonymousAuthProvider) else { return }
        
        inProgress = true
        
        anonymousAuthProvider.loginAnonymously {[weak self] authError in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                if let authError{
                    print(authError.localizedDescription)
                }
                self?.inProgress = false
            }
        }
    }
}

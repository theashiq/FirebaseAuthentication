//
//  SocialAuthenticationViewModel.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/14/23.
//

import Foundation

class SocialAuthenticationViewModel: AlerterViewModel{
    
    private(set) var socialAuthProvider: SocialAuthProvider
    
    @Published private(set) var inProgress: Bool = false
    @Published private(set) var socialAuthOptions: [SocialAuthOption] = []
    
    
    init(socialAuthProvider: SocialAuthProvider) {
        self.socialAuthProvider = socialAuthProvider
        self.socialAuthOptions = socialAuthProvider.supportedSocialOptions.filter({ _ in true })
    }
    
    // MARK: - User Intents
    
    func socialLogin(option: SocialAuthOption, onProgressComplete: @escaping ()-> Void){
        
        guard !inProgress else {
            self.alert = .authErrorAlert(from: .loading)
            onProgressComplete()
            return
        }
                        
        socialAuthProvider.socialLogin(option: option) {[weak self] authError in
            DispatchQueue.main.async{
                if let authError{
                    self?.alert = .authErrorAlert(from: authError)
                }
                else{
                    self?.alert = .authErrorAlert(from: .loginFail)
                }
                onProgressComplete()
            }
        }
    }
}

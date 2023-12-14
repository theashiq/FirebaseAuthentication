//
//  AnonymousAuthenticationViewModel.swift
//  FirebaseAuthentication
//
//  Created by mac 2019 on 12/15/23.
//

import Foundation

class AnonymousAuthenticationViewModel: AlerterViewModel{
    
    private(set) var anonymousAuthProvider: AnonymousAuthProvider
    @Published private(set) var inProgress: Bool = false
    
    init(anonymousAuthProvider: AnonymousAuthProvider) {
        self.anonymousAuthProvider = anonymousAuthProvider
    }
    
    // MARK: - User Intents
    func loginAnonymously(onProgressComplete: @escaping ()-> Void){
        guard !inProgress else {
            self.alert = .authErrorAlert(from: .loading)
            onProgressComplete()
            return
        }
        
        anonymousAuthProvider.loginAnonymously {[weak self] authError in
            DispatchQueue.main.async{
                if let authError{
                    self?.alert = .authErrorAlert(from: authError)
                }
                onProgressComplete()
            }
        }
    }
}

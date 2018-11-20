//
//  UserViewModel.swift
//  MVVMRWDevCon
//
//  Created by Admin on 20/11/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum UserValidationState {
    case Valid
    case Invalid(String)
}

class UserViewModel {
    private let minUserNameLenght = 4
    private let minPasswordLenght = 5
    private let codeRefreshTime = 5.0
    
    private var user = User() {
        didSet {
            username.value = user.username
        }
    }
    
    var username: Dynamic<String> = Dynamic("")
    
    var password: String {
        return user.password
    }
    
    var accessCode: Dynamic<String?> = Dynamic(nil)
    
    var protectedUserName: String {
        let characters = username.value.characters
        
        if characters.count >= minUserNameLenght {
            var displayName = [Character]()
            
            for (index, character) in characters.enumerated() {
                if index > characters.count - minUserNameLenght {
                    displayName.append(character)
                } else {
                    displayName.append("*")
                }
            }
            return String(displayName)
        }
        return username.value
    }
    
    init(user: User = User()) {
        self.user = user
        startAccessCodeTimer()
    }
}

extension UserViewModel {
    func updateUserName(_ userName: String) {
       user.username = username.value
    }
    
    func updatePassword(_ password: String) {
        user.password = password
    }
    
    func validate() -> UserValidationState {
        if user.username.isEmpty || user.password.isEmpty {
            return .Invalid("User name and Password are required.")
        }
        
        if user.username.count < minUserNameLenght {
            return .Invalid("")
        }
        
        if user.password.count < minPasswordLenght {
            return .Invalid("")
        }
        
        return .Valid
    }
    
    func login(_ completion: @escaping(_ errorString: String?) -> Void) {
        LoginService().loginWithUserName(user.username, password: user.password, { (success) in
            if success {
                completion(nil)
            } else {
                completion("Invalid credentionals.")
            }
        })
    }
}

private extension UserViewModel {
    func startAccessCodeTimer() {
       accessCode.value = LoginService().generateAccessCode()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + codeRefreshTime) { [weak self] in
            self?.startAccessCodeTimer()
        }
    }
}

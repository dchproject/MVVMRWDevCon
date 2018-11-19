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
    private var user = User()
    
    var username: String {
        return user.username
    }
    
    var password: String {
        return user.password
    }
    
    var protectedUserName: String {
        let characters = username.characters
        
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
        return username
    }
}

extension UserViewModel {
    func updateUserName(_ userName: String) {
       user.username = username
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

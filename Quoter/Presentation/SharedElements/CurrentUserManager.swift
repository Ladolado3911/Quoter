//
//  CurrentUserManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/4/22.
//

import UIKit

enum UserDefaultsKeys: String {
    case userIDToKeepSignedIn
}

final class CurrentUserLocalManager {
    
    static let shared = CurrentUserLocalManager()
    
    var isUserSignedIn: Bool {
        getCurrentUserID() != nil
    }
 
    private init() {}
    
    //MARK: To keep user signed in
    func persistUserIDAfterSignIn(id: UUID) {
        UserDefaults.standard.set(id.uuidString, forKey: UserDefaultsKeys.userIDToKeepSignedIn.rawValue)
    }
    
    func getCurrentUserID() -> String? {
        if let id = UserDefaults.standard.string(forKey: UserDefaultsKeys.userIDToKeepSignedIn.rawValue) {
            return id
        }
        else {
            return nil
        }
    }
    
    func deleteUserIDAfterSignOut() {
        UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.userIDToKeepSignedIn.rawValue)
    }
    
}

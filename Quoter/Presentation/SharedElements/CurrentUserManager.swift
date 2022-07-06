//
//  CurrentUserManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/4/22.
//

import UIKit
import AuthenticationServices

enum UserDefaultsKeys: String {
    case userIDToKeepSignedIn
    case userType
}

final class CurrentUserLocalManager {
    
    static let shared = CurrentUserLocalManager()
    
    var type: AccountType? {
        if let type = UserDefaults.standard.string(forKey: UserDefaultsKeys.userType.rawValue) {
            let newType = AccountType.init(rawValue: type)
            return newType!
        }
        else {
            return nil
        }
    }
    
    var isUserSignedIn: Bool {
        switch type {
        case .quotie:
            return getCurrentUserID() != nil
        case .apple:
            return getCurrentUserID() != nil
        case .google:
            return getCurrentUserID() != nil
        default:
            return getCurrentUserID() != nil
        }
    }
 
    private init() {}
    
//    func isUserSignedIn(completion: @escaping (Bool) -> UIViewController) {
//        switch type {
//        case .quotie:
//            completion(getCurrentUserID() != nil)
//        case .apple:
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: getCurrentUserID()!) { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    completion(true)
//                case .revoked:
//                    // The Apple ID credential is revoked.
//                    completion(false)
//                case .notFound:
//                    // No credential was found, so show the sign-in UI.
//                    completion(false)
//                default:
//                    break
//                }
//            }
//        case .google:
//            completion(getCurrentUserID() != nil)
//        }
//    }
    
    //MARK: To keep user signed in
    func persistUserIDAfterSignIn(id: UUID, type: AccountType) {
        UserDefaults.standard.set(id.uuidString, forKey: UserDefaultsKeys.userIDToKeepSignedIn.rawValue)
        UserDefaults.standard.set(type.rawValue, forKey: UserDefaultsKeys.userType.rawValue)
    }
    
    func persistUserIDAfterSignIn(idString: String, type: AccountType) {
        UserDefaults.standard.set(idString, forKey: UserDefaultsKeys.userIDToKeepSignedIn.rawValue)
        UserDefaults.standard.set(type.rawValue, forKey: UserDefaultsKeys.userType.rawValue)
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

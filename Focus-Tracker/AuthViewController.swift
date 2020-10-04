//
//  AuthViewController.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/2/20.
//

import Foundation
import FirebaseUI
import UIKit

class AuthViewController: UITabBarController, FUIAuthDelegate {
    let authUI = FUIAuth.defaultAuthUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth(),
            FUIFacebookAuth(),
        ]
        authUI!.providers = providers
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("User already logged in.", user)
                FirestoreManager.shared.userToken = Auth.auth().currentUser!.uid
                
                if AppSettings.shared.isFirstRun {
                    FirestoreManager.shared.setDayHours(AppSettings.shared.dayHours)
                    FirestoreManager.shared.setWorkHours(AppSettings.shared.workHours)
                    AppSettings.shared.isFirstRun = false
                }
            } else {
                self.showLoginScreen()
            }
        }
    }
    
    
    @objc func signOutButtonPressed() {
        do {
            try authUI?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func showLoginScreen() {
        authUI?.isInteractiveDismissEnabled = false
        authUI?.shouldHideCancelButton = true
        let authViewController = authUI!.authViewController()
        authViewController.navigationBar.topItem?.title = "Welcome to Mindfully"
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
}


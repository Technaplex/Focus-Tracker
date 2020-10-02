//
//  AuthViewController.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/2/20.
//

import Foundation
import FirebaseUI

class AuthViewController: UIViewController, FUIAuthDelegate {
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
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.signOutButtonPressed))
                
                // User is logged in, what to do?
            } else {
                
                self.showLoginScreen()
            }
            
        }
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    @objc func signOutButtonPressed() {
        do {
            try authUI?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func showLoginScreen() {
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
            
    }
}


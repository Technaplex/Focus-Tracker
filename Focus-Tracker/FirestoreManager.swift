//
//  FirestoreManager.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/2/20.
//

import Foundation
import Firebase

class FirestoreManager {
    static let shared = FirestoreManager(Auth.auth().currentUser?.getIDTokenForcingRefresh(false))
    private let userRef : DocumentReference
    private let db = Firestore.firestore()
    
    private init(_ userToken: String?){
        self.userRef = db.collection("users").document(userToken!)
    }
    
    func getSessions(){
        return userRef.collection("sessions").return
    }
}

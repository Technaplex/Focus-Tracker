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
        return userRef.collection("sessions").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                return (querySnapshot!.documents).map({$0.data()})
            }
        }
    }
    
    func getActivities(_ sessId: String){
        return userRef.collection("sessions").document(sessId).collection("activities").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                return (querySnapshot!.documents).map({$0.data()})
            }
        }
    }
    
    func getActivity(_ actId: String, sessId: String){
        let actRef = return userRef.collection("sessions").document(sessId).collection("activities").document(actId)
        actRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                return document.data()
            } else {
                print("Error during Firestore read: \(err)")
            }
        }
    }
    
//    func getSession(_ id: String){
//        getSessions()
//    }
    
    func addSession(_ sessId: String, data: [String: Any]){
        userRef.collection("sessions").document(sessId).setData(data) {err in
            if let err = err{
                print("Error on write: \(err)")
            }
        }
    }
    
    func addActivity(_ actId: String, sessId: String, data: [String: Any]){
        userRef.collection("sessions").document(sessId).collection("activities").document(actId).setData(data) { err in
            if let err = err {
                print("Error on write: \(err)")
            }
        }
    }
}

//
//  FirestoreManager.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/2/20.
//

import Foundation
import Firebase

class FirestoreManager {
    static let shared = FirestoreManager()
    private var userRef : DocumentReference
    private var userToken : String
    private let db = Firestore.firestore()
    
    private init() {
        Auth.auth().currentUser?.getIDToken(completion: {(userToken, err) -> Void in
            if let err = err {
                print("Error during user authentication: \(err)")
            } else {
                self.userToken = userToken!
            }
        })
        self.userRef = db.collection("users").document(userToken)
    }
    
    func allSessions(completion: @escaping ([Session]) -> Void) {
        return userRef.collection("sessions").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                completion((querySnapshot!.documents).map({Session($0.data(), fs: true)!}))
            }
        }
    }
    
    func allActivities(_ sessId: String, completion: @escaping ([Activity]) -> Void){
        return userRef.collection("sessions").document(sessId).collection("activities").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                completion((querySnapshot!.documents).map({Activity($0.data())!}))
            }
        }
    }
    
    func getSession(_ sessId: String, completion: @escaping (Session) -> Void){
        let sessRef = userRef.collection("sessions").document(sessId)
        sessRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(Session(document.data()!, fs: true)!)
            } else {
                print("Error during Firestore read: \(error)")
            }
        }
    }
    
    func getActivity(_ actId: String, sessId: String, completion: @escaping (Activity) -> Void){
        let actRef = userRef.collection("sessions").document(sessId).collection("activities").document(actId)
        actRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(Activity(document.data()!)!)
            } else {
                print("Error during Firestore read: \(error)")
            }
        }
    }
    
//    func getSession(_ id: String){
//        getSessions()
//    }
    
    
    func addSession(_ sessId: String, data: Session){
        userRef.collection("sessions").document(sessId).setData(data.dict) {err in
            if let err = err{
                print("Error on write: \(err)")
            }
        }
    }
    
    func addActivity(_ actId: String, sessId: String, data: Activity){
        userRef.collection("sessions").document(sessId).collection("activities").document(actId).setData(data.dict) { err in
            if let err = err {
                print("Error on write: \(err)")
            }
        }
    }
}

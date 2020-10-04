//
//  FirestoreManager.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/2/20.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    private var userToken : String = ""
    
    private init() {
        Auth.auth().currentUser?.getIDToken(completion: {(userToken, err) -> Void in
            if let err = err {
                print("Error during user authentication: \(err)")
            } else {
                self.userToken = userToken!
            }
        })
    }
    
    // Commented out because unused for Hackathon
    /*
    func allSessions(completion: @escaping ([Session]) -> Void) {
        return db.collection("users").document(userToken).collection("sessions").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                completion((querySnapshot!.documents).map({Session($0.data())!}))
            }
        }
    }
    
    func allActivities(_ sessId: String, completion: @escaping ([Activity]) -> Void){
        return db.collection("users").document(userToken).collection("sessions").document(sessId).collection("activities").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                completion((querySnapshot!.documents).map({Activity($0.data())!}))
            }
        }
    }
    
    func getSession(_ sessId: String, completion: @escaping (Session) -> Void){
        let sessRef = db.collection("users").document(userToken).collection("sessions").document(sessId)
        sessRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(Session(document.data()!)!)
            } else {
                print("Error during Firestore read: \(error)")
            }
        }
    }
    
    func getActivity(_ actId: String, sessId: String, completion: @escaping (Activity) -> Void){
        let actRef = db.collection("users").document(userToken).collection("sessions").document(sessId).collection("activities").document(actId)
        actRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(Activity(document.data()!)!)
            } else {
                print("Error during Firestore read: \(error)")
            }
        }
    }
    */
    
//    func getSession(_ id: String){
//        getSessions()
//    }
    
    /// Add Session should add a session from a stopped timer session.
    func addSession(_ sessId: String, data: Session){
        db.collection("users").document(userToken).collection("sessions").document(sessId).setData(data.toDict()) {err in
            if let err = err{
                print("Error on write: \(err)")
            }
        }
    }
    
    /*
    func addActivity(_ actId: String, sessId: String, data: Activity){
        db.collection("users").document(userToken).collection("sessions").document(sessId).collection("activities").document(actId).setData(data.toDict()) { err in
            if let err = err {
                print("Error on write: \(err)")
            }
        }
    }
    */
}

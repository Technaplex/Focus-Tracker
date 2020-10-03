//
//  FirestoreManager.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/2/20.
//

import Foundation
import Firebase

//struct Session {
//
//    var id: String
//    var date: String
//    var timeStart: String
//    var timeEnd: String
//
//    init?(data: [String: Any]) {
//
//        guard let id = data["id"] as? String,
//            let date = data["date"] as? String,
//            let timeStart = data["timeStart"] as? String,
//            let timeEnd = info["timeEnd"] as? String else {
//                return nil
//        }
//
//        self.id = id
//        self.date = date
//        self.timeStart = timeStart
//        self.timeEnd = timeEnd
//
//    }
//
//}
//
//struct Activity {
//
//    var id: String
//    var sessId: String
//    var name: String
//    var duration: Double
//    var interrupts: Int
//
//    init?(data: [String: Any]) {
//
//        guard let id = data["id"] as? String,
//            let sessId = data["sessId"] as? String,
//            let name = data["name"] as? String,
//            let duration = Double(data["duration"]),
//            let interrupts = Int(data["interrupts"]) else {
//            return nil
//        }
//
//        self.id = id
//        self.sessId = sessId
//        self.name = name
//        self.duration = duration
//        self.interrupts = interrupts
//
//    }
//
//}

class FirestoreManager {
//    static let shared = FirestoreManager(Auth.auth().currentUser?.getIDTokenForcingRefresh(false))
    private let userRef : DocumentReference
    private let userToken : String
    private let db = Firestore.firestore()
    
    private init(_ userToken: String?) {
        self.userRef = db.collection("users").document(userToken!)
        self.userToken = userToken!
    }
    
    func allSessions(completion: @escaping (([[String: Any]]) -> ())) {
        return userRef.collection("sessions").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                completion((querySnapshot!.documents).map({$0.data()}))
            }
        }
    }
    
    func allActivities(_ sessId: String, completion: @escaping (([[String: Any]]) -> ())){
        return userRef.collection("sessions").document(sessId).collection("activities").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                completion((querySnapshot!.documents).map({$0.data()}))
            }
        }
    }
    
    func getSession(_ sessId: String, completion: @escaping (([String: Any]) -> ())){
        let sessRef = db.collection("users").document(userToken).collection("sessions").document(sessId)
        sessRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.data()!)
            } else {
                print("Error during Firestore read: \(error)")
            }
        }
    }
    
    func getActivity(_ actId: String, sessId: String, completion: @escaping (([String: Any]) -> ())){
        let actRef = db.collection("users").document(userToken).collection("sessions").document(sessId).collection("activities").document(actId)
        actRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.data()!)
            } else {
                print("Error during Firestore read: \(error)")
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

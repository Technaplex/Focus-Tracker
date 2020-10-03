//
//  FirestoreManager.swift
//  Focus-Tracker
//
//  Created by Bryan Li on 10/2/20.
//

import Foundation
import Firebase

struct Session {

    var id: String
    var date: String
    var timeStart: TimeInterval
    var timeEnd: TimeInterval
    var dict: [String : Any]{
        return ["id": id,
                "date": date,
                "timeStart": timeStart,
                "timeEnd": timeEnd]
    }
    init?(_ data: [String: Any]) {

        guard let id = data["id"] as? String,
            let date = data["date"] as? String,
            let timeStart = data["timeStart"] as? Double,
            let timeEnd = data["timeEnd"] as? Double else {
                return nil
        }

        self.id = id
        self.date = date
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }

}

struct Activity {

    var id: String
    var sessId: String
    var name: String
    var duration: Double
    var interrupts: Int
    var dict: [String : Any]{
        return ["id": id,
                "sessId": sessId,
                "name": name,
                "duration": duration,
                "interrupts": interrupts]
    }
    init?(_ data: [String: Any]) {

        guard let id = data["id"] as? String,
            let sessId = data["sessId"] as? String,
            let name = data["name"] as? String,
            let duration = data["duration"] as? Double,
            let interrupts = data["interrupts"] as? Int else {
                return nil
        }

        self.id = id
        self.sessId = sessId
        self.name = name
        self.duration = duration
        self.interrupts = interrupts

    }

}

class FirestoreManager {
//    static let shared = FirestoreManager(Auth.auth().currentUser?.getIDTokenForcingRefresh(false))
    private let userRef : DocumentReference
    private let userToken : String
    private let db = Firestore.firestore()
    
    private init(_ userToken: String?) {
        self.userRef = db.collection("users").document(userToken!)
        self.userToken = userToken!
    }
    
    func allSessions(completion: @escaping ([Session]) -> Void) {
        return userRef.collection("sessions").getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error during Firestore read: \(err)")
            } else {
                completion((querySnapshot!.documents).map({Session($0.data())!}))
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

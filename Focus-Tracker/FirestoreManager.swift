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
    var userToken : String = ""

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
    func addSession(_ sessId: String, data: Session) {
        db.collection("users").document(userToken).collection("sessions").document(sessId).setData(data.toDict()) {err in
            if let err = err{
                print("Error on write (addSession): \(err)")
            }
        }
    }
    
    func setDayHours(_ dayHours: HourRange) {
        db.collection("users").document(userToken).setData(["dayHours": dayHours.hash()]) { err in
            if let err = err {
                print("Error writing document (setDayHours): \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setWorkHours(_ workHours: HourRange) {
        db.collection("users").document(userToken).setData(["workHours": workHours.hash()]) { err in
            if let err = err {
                print("Error writing document (setWorkHours): \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func getStudyDays(completion: @escaping ([StudyDay]) -> Void){
        print(userToken)
        let userRef = db.collection("users").document(userToken)
        var studyDays = [StudyDay]()
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data : [String : Any] = document.data()!
                print(data)
                let hist : [String : Any] = data["hist"] as! [String : Any]
                print(hist)
                for (key, value) in hist {
                    let dayValues = value as! [String : Any]
                    let date = Date(timeIntervalSince1970: Double(key)! / 1000)
                    let dayHours = HourRange.from_hash(self.convertTime(dayValues["dstart"] as! Int) + self.convertTime(dayValues["dend"] as! Int))
                    let workHours = HourRange.from_hash(self.convertTime(dayValues["wstart"] as! Int) + self.convertTime(dayValues["wend"] as! Int))
                    let categories = CategoryInfo(
                        mindfulWork:
                            Duration(time: self.convertTime(dayValues["0"] as! Int)),
                        mindfulPlay:
                            Duration(time: self.convertTime(dayValues["1"] as! Int)),
                        mindlessWork:
                            Duration(time: self.convertTime(dayValues["2"] as! Int)),
                        mindlessPlay:
                            Duration(time: self.convertTime(dayValues["3"] as! Int))
                    )
                    studyDays.append(StudyDay(date: date, dayHours: dayHours, workHours: workHours, categories: categories))
                }
                completion(studyDays)
            } else {
                print("Error during Firestore read (getStudyDays): \(error)")
            }
        }
    }
    
    private func convertTime(_ ms: Int) -> [Int] {

        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        
        hours = ms / 3600000
        minutes = (ms - hours * 3600000) / 60000
        seconds = (ms - hours * 3600000 - minutes * 60000) / 1000
        
        return [hours, minutes, seconds]
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



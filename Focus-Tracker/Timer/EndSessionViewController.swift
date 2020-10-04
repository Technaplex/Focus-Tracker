//
//  FinishSessionViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/3/20.
//

import UIKit

class EndSessionViewController: UIViewController {
    @IBOutlet weak var sessionStartDatePicker: UIDatePicker!
    @IBOutlet weak var sessionEndDatePicker: UIDatePicker!
    @IBOutlet weak var interruptsTextField: UITextField!
    @IBOutlet weak var interruptStepper: UIStepper!
    var start: Date!
    var interrupts: Int!
    var activities: [Activity]!
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionStartDatePicker.date = start
        sessionEndDatePicker.date = Date()
        interruptStepper.value = Double(interrupts)
        interruptsTextField.text = String(interrupts)
    }
    
    @IBAction func interruptValueChanged(_ sender: Any) {
        interrupts = Int(interruptStepper.value)
        interruptsTextField.text = String(interrupts)
    }
    
    // MARK: - Navigation

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveSession(_ sender: Any) {
        AppSettings.shared.timerStartDate = nil
        AppSettings.shared.interrupts = 0
        let currentSession = Session(
            id: createUUID(),
            date: sessionStartDatePicker.date,
            start: sessionStartDatePicker.date,
            end: sessionEndDatePicker.date, // Explain why this used to be
            interrupts: interrupts,
            activities: activities,
            category: category.toInt())
            
        FirestoreManager.shared.addSession(currentSession.id, data: currentSession)
        print("session saved")
        
        let timer = self.timer()
        timer.addActivity()
        timer.shiftsDataSource.clear()
        
        self.performSegue(withIdentifier: "unwind", sender: self)
    }
    
    @IBAction func discardSession(_ sender: Any) {
        AppSettings.shared.timerStartDate = nil
        AppSettings.shared.interrupts = 0
        self.timer().shiftsDataSource.clear()
        self.performSegue(withIdentifier: "unwind", sender: self)
    }
    
    func timer() -> CurrentTimerViewController{
        let presenter = presentingViewController as! UITabBarController
        let timer = (presenter.viewControllers![0] as! UINavigationController).topViewController as! CurrentTimerViewController
       
        return timer
    }
}

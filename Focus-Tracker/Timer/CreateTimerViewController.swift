//
//  CreateTimerViewController.swift
//  Focus-Tracker
//
//  Created by Simon Chervenak on 10/2/20.
//

import Foundation
import UIKit

class CreateTimerViewController: UIViewController {
    @IBOutlet var type: UISegmentedControl!
    @IBOutlet var activity: UITextField!
    @IBOutlet var goal: UITextField!
    
    /*
         @IBAction func start(_ sender: Any) {
             let presenter = presentingViewController as! UITabBarController
        
             // Definitely feels like there's a better way to do this
             let timer = (presenter.viewControllers![0] as! UINavigationController).topViewController as! CurrentTimerViewController
        
     //        timer.activityLabel.text = "Text: Mindful \(type.titleForSegment(at: type.selectedSegmentIndex)!)"
        
             if type.selectedSegmentIndex == 0 {
                 timer.category = Category.mindfulWork
             } else {
                 timer.category = Category.mindfulPlay
             }
        
             timer.activity = activity.text!
             timer.goal = Int(goal.text!)! * 60
        
             timer.startTimer()
        
             dismiss(animated: true, completion: nil)
         }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func updateDefaultGoalTime() {
        if type.selectedSegmentIndex == 0 {
            goal.text = String(AppSettings.shared.workSessionGoal)
        } else {
            goal.text = String(AppSettings.shared.playSessionGoal)
        }
    }
    
    @IBAction func sessionTypeChanged(_ sender: Any) {
        updateDefaultGoalTime()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "showTimer":
            guard let currentTimerViewController = segue.destination as? CurrentTimerViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            if type.selectedSegmentIndex == 0 {
                currentTimerViewController.category = Category.mindfulWork
            } else {
                currentTimerViewController.category = Category.mindfulPlay
            }
            AppSettings.shared.timerCategory = currentTimerViewController.category
            
            currentTimerViewController.activity = activity.text!
            AppSettings.shared.activity = activity.text!
            
            currentTimerViewController.running = true
            currentTimerViewController.goal = Int(goal.text!)! * 60
        default: fatalError("Unexpected segue")
        }
    }
    
    @IBAction func unwindToCreateTimer(unwindSegue: UIStoryboardSegue) {
        loadViewIfNeeded()
        updateDefaultGoalTime()
        activity.text = ""
    }
}

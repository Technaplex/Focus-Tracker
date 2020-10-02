//
//  CreateTimerViewController.swift
//  Focus-Tracker
//
//  Created by Simon Chervenak on 10/2/20.
//

import Foundation
import UIKit

class CreateTimerViewController: UIViewController {
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var focus: UISegmentedControl!
    @IBOutlet weak var activity: UITextField!
    @IBOutlet weak var goal: UITextField!
    
    @IBAction func start(_ sender: Any) {
        let presenter = presentingViewController as! UITabBarController
        
        let timer = (presenter.viewControllers![0] as! UINavigationController).topViewController as! CurrentTimerViewController
        
        timer.typeLabel.text = "Text: \(focus.titleForSegment(at: focus.selectedSegmentIndex)!) \(type.titleForSegment(at: type.selectedSegmentIndex)!)"
        timer.activityLabel.text = "Activity: \(activity.text!)"
        timer.running = true
        timer.goal = Int(goal.text!)! * 60
        
        timer.start_timer()
        
        dismiss(animated: true, completion: nil)
    }
}

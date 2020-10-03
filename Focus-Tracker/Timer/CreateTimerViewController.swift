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
    @IBOutlet weak var activity: UITextField!
    @IBOutlet weak var goal: UITextField!
    
    @IBAction func start(_ sender: Any) {
        let presenter = presentingViewController as! UITabBarController
        
        // Definitely feels like there's a better way to do this
        let timer = (presenter.viewControllers![0] as! UINavigationController).topViewController as! CurrentTimerViewController
        
        timer.typeLabel.text = "Text: Mindful \(type.titleForSegment(at: type.selectedSegmentIndex)!)"
        
        timer.activity = activity.text!
        timer.running = true
        timer.goal = Int(goal.text!)! * 60
        
        timer.start_timer()
        
        dismiss(animated: true, completion: nil)
    }
}
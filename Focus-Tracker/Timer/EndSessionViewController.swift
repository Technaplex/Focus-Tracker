//
//  FinishSessionViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/3/20.
//

import UIKit

class EndSessionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Navigation

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveSession(_ sender: Any) {
        let presenter = presentingViewController as! UITabBarController

        let timer = (presenter.viewControllers![0] as! UINavigationController).topViewController as! CurrentTimerViewController

        let currentSession = Session(
            id: createUUID(),
            date: timer.start,
            start: timer.start,
            end: timer.last_lap,
            interrupts: timer.interrupts,
            activities: timer.activities,
            category: timer.category.toInt())
            
        FirestoreManager.shared.addSession(currentSession.id, data: currentSession)
    }
}

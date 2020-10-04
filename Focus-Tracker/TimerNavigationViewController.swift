//
//  TimerNavigationViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/4/20.
//

import UIKit

class TimerNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Timer", bundle: nil)
        self.viewControllers = [storyBoard.instantiateViewController(withIdentifier: "createSessionViewController")]
        
        if AppSettings.shared.timerStartDate != nil {
            self.viewControllers.append(storyBoard.instantiateViewController(withIdentifier: "timerViewController"))
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

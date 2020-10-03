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
}

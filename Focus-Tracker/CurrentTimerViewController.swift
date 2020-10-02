//
//  CurrentTimerViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import UIKit

class CurrentTimerViewController: UIViewController {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var interruptValueTextField: UITextField!
    @IBOutlet weak var shiftsTableView: UITableView!
    
    var start: Date!
    var timer: Timer!
    
    var shiftsDataSource = ShiftsDataSource()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shiftsTableView.delegate = shiftsDataSource
        shiftsDataSource.delegate = self
        
        start = Date()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(self.update_timer),
                                                   userInfo: nil,
                                                   repeats: true)
    }
    
    @objc func update_timer() {
        let interval = Int(Date().timeIntervalSince(start))
        
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        let seconds = interval % 60

        self.timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: - Actions
    
    @IBAction func shiftActivity(_ sender: Any) {
        // TODO: Undummy this
        shiftsDataSource.add(shift: Shift(activity: "CHICKEN", start: Date(), end: Date()))
    }
    
    @IBAction func endSession(_ sender: Any) {
    }
    
    @IBAction func interruptValueChanged(_ sender: Any) {
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension CurrentTimerViewController: ShiftsDataSourceDelegate {
    // Crude, could specific rows/etc
    func shiftValueDidChange() {
        shiftsTableView.reloadData()
    }
    
}

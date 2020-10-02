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
    
    
    var shiftsDataSource = ShiftsDataSource()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shiftsTableView.delegate = shiftsDataSource
        shiftsDataSource.delegate = self
        
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

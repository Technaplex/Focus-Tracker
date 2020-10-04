//
//  CurrentTimerViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import UIKit

func timedeltaToString(_ interval: Int) -> String {
    let hours = interval / 3600
    let minutes = (interval % 3600) / 60
    let seconds = interval % 60

    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

class CurrentTimerViewController: UIViewController {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var interruptValueTextField: UITextField!
    @IBOutlet weak var shiftsTableView: UITableView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var interruptStepper: UIStepper!
    
    var start: Date!
    var timer: Timer!
    var activity = ""
    var last_lap: Date!
    var goal = 1500 // goal in seconds (this is 25 minutes)
    var running = false
    
    var shiftsDataSource = ShiftsDataSource()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shiftsTableView.delegate = shiftsDataSource
        shiftsTableView.dataSource = shiftsDataSource

        shiftsDataSource.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(self.updateTimer),
                                                   userInfo: nil,
                                                   repeats: true)
        
        // if a timer was previously running when the app closed, make a new timer which
        // shows the time since that date, so it looks as if the timer was running while
        // the app was closed
        if let startDate = AppSettings.shared.timerStartDate {
            print(startDate)
            startTimer(atDate: startDate)
            running = true
        }
        
        if !running {
            performSegue(withIdentifier: "create_timer", sender: self)
        }
    }
    
    // if I use the name `date` instead of `date_`, it crashes...
    func startTimer(atDate date_: Date? = nil) {
        activityLabel.text = "Activity: \(activity)"
        goalLabel.text = "Goal: \(goal / 60) minutes"
        start = date_ ?? Date()
        // don't overwrite if it's nonnull, because we don't want to change the start date for
        // a current session
        if AppSettings.shared.timerStartDate == nil {
            AppSettings.shared.timerStartDate = start
        }
        last_lap = start
    }
    
    @objc func updateTimer() {
        if !running {
            return
        }
        
        let interval = Int(Date().timeIntervalSince(start))
        
        let progress = CGFloat(interval) / CGFloat(goal)
        
        self.timerLabel.text = timedeltaToString(interval)
        self.timerLabel.textColor = UIColor(red: 1 - progress,
                                            green: 0,
                                            blue: progress,
                                            alpha: 1.0)
    }
    
    // MARK: - Actions
    
    @IBAction func addShift(_ sender: Any) {
        let end = Date()
        shiftsDataSource.add(shift: Shift(activity: activity == "" ? "None" : activity, start: last_lap, end: end))
        last_lap = end
        
        self.createNewActivity()
    }
    
    @IBAction func endSession(_ sender: Any) {
        // reset the start date so we don't think we need to continue a session when we close and
        // reopen the app
        AppSettings.shared.timerStartDate = nil
    }
    
    @IBAction func interruptValueChanged(_ sender: Any) {
        interruptValueTextField.text = "\(interruptStepper.value)"
    }
    
    func createNewActivity() {
        let ac = UIAlertController(title: "Activity Name:", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            self.activity = ac.textFields![0].text!
        }
        ac.addAction(submitAction)

        present(ac, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "create_timer": break;
        default: break;
        }
    }

    
}

extension CurrentTimerViewController: ShiftsDataSourceDelegate {
    // Crude, could specific rows/etc
    func shiftValueDidChange() {
        shiftsTableView.reloadData()
    }
}

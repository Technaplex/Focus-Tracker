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

func createUUID() -> String {
    return UUID().uuidString.replacingOccurrences(of: "-", with: "")
}

class CurrentTimerViewController: UIViewController {
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var interruptValueTextField: UITextField!
    @IBOutlet weak var shiftsTableView: UITableView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var interruptStepper: UIStepper!
    
    var start: Date!
    var timer: Timer!
    var activity = "Example Activity"
    var last_lap: Date!
    var goal = 1500 // goal in seconds (this is 25 minutes)
    var running = false
    var activities: [Activity] = []
    // set to mindfulWork just so it's nonnull, will be set to real value later
    var category = Category.mindfulWork
    var interrupts = 0
    
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
            startTimer(atDate: startDate)
        } else {
            startTimer()
        }
        
        running = true
        
        if let timerCategory = AppSettings.shared.timerCategory {
            category = timerCategory
            print("CHICKENSDFJLSDKF")
            updateActivityLabel()
        }
        
        interrupts = AppSettings.shared.interrupts

        self.navigationItem.setHidesBackButton(true, animated: true)
//        if !running {
//            performSegue(withIdentifier: "create_timer", sender: self)
//        }
    }
    
    // MARK: - Actions
    
    @IBAction func addShift(_ sender: Any) {
        addActivity()
        self.createNewActivity()
    }
    
    func addActivity() {
        let end = Date()

        let name = activity == "" ? "None" : activity
    
        shiftsDataSource.add(shift: Shift(activity: name, start: last_lap, end: end))
        activities.append(Activity(
                            id: createUUID(),
                            name: name,
                            start: last_lap,
                            end: end))
        
        last_lap = end
        
        
    }
    
    @IBAction func endSession(_ sender: Any) {
        // reset the start date so we don't think we need to continue a session when we close and
        // reopen the app
        AppSettings.shared.timerStartDate = nil
        AppSettings.shared.interrupts = 0
        addActivity()
    }
    
    @IBAction func interruptValueChanged(_ sender: Any) {
        interrupts = Int(interruptStepper.value)
        interruptValueTextField.text = "\(interrupts)"
    }
    
    func createNewActivity() {
        let ac = UIAlertController(title: "Activity Name:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            self.activity = ac.textFields![0].text!
            self.updateActivityLabel()
        }
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)

        present(ac, animated: true)
    }

    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        switch segue.identifier {
//        case "create_timer": break;
//        default: break;
//        }
//    }
    
}

// MARK: - Timer
extension CurrentTimerViewController {
    // if I use the name `date` instead of `date_`, it crashes...
    func startTimer(atDate date_: Date? = nil) {
        updateActivityLabel()
        goalLabel.text = "Goal: \(goal / 60) minutes"
        start = date_ ?? Date()
        // don't overwrite if it's nonnull, because we don't want to change the start date for
        // a current session
        if AppSettings.shared.timerStartDate == nil {
            AppSettings.shared.timerStartDate = start
        }
        last_lap = start
    }
    
    func updateActivityLabel() {
        let activityText = activity != "" ? activity : "Unspecified"
        activityLabel.text = "\(activityText) (\(String(describing: category)))"
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
}

extension CurrentTimerViewController: ShiftsDataSourceDelegate {
    // Crude, could specific rows/etc
    func shiftValueDidChange() {
        shiftsTableView.reloadData()
    }
}

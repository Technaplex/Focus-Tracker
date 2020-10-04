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
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var interruptValueTextField: UITextField!
    @IBOutlet var shiftsTableView: UITableView!
    @IBOutlet var goalLabel: UILabel!
    @IBOutlet var interruptStepper: UIStepper!
    
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
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        
        // if a timer was previously running when the app closed, make a new timer which
        // shows the time since that date, so it looks as if the timer was running while
        // the app was closed
        
        running = true

        if let startDate = AppSettings.shared.timerStartDate {
            startTimer(atDate: startDate)
        } else {
            startTimer()
        }
        
        updateTimerText()
        
        if let timerCategory = AppSettings.shared.timerCategory {
            category = timerCategory
        }
        
        interrupts = AppSettings.shared.interrupts
        
        if let act = AppSettings.shared.activity {
            activity = act
        }
        
        updateActivityLabel()

        navigationItem.setHidesBackButton(true, animated: true)
        
        shiftsDataSource.loadShifts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Actions
    
    @IBAction func addShift(_ sender: Any) {
        createNewActivity()
    }
    
    func addActivity() {
        let end = Date()

        let name = activity == "" ? "Unspecified" : activity
    
        shiftsDataSource.add(shift: Shift(activity: name, start: last_lap, end: end))
        activities.append(Activity(
            id: createUUID(),
            name: name,
            start: last_lap,
            end: end))
        
        last_lap = end
    }
    
    @IBAction func endSession(_ sender: Any) {
        // TODO: Fix so that activity is not added when Stop is clicked. Instead, add the activity in the 'save session' method of end session controller
        // reset the start date so we don't think we need to continue a session when we close and
        // reopen the app
        
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
            self.addActivity()
            self.activity = ac.textFields![0].text!
            AppSettings.shared.activity = self.activity
            self.updateActivityLabel()
        }
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)

        present(ac, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "endSession":
            guard let endSessionViewController = segue.destination as? EndSessionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            endSessionViewController.start = start
            endSessionViewController.interrupts = interrupts
            endSessionViewController.activities = activities
            endSessionViewController.category = category
            
        default: fatalError("Unexpected segue")
        }
    }
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
        interruptValueTextField.text = "\(interrupts)"
    }
    
    @objc func updateTimer() {
        if !running {
            return
        }
        
        updateTimerText()
    }
    
    func updateTimerText() {
        let interval = Int(Date().timeIntervalSince(start))
        
        let progress = CGFloat(interval) / CGFloat(goal)
        
        timerLabel.text = timedeltaToString(interval)
        timerLabel.textColor = UIColor(red: 1 - progress,
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

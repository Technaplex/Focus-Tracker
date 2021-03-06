//
//  SettingsTableViewController.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/1/20.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var dayStartDatePicker: UIDatePicker!
    @IBOutlet weak var dayEndDatePicker: UIDatePicker!
    @IBOutlet weak var workStartDatePicker: UIDatePicker!
    @IBOutlet weak var workEndDatePicker: UIDatePicker!
    @IBOutlet weak var playSessionGoalTF: UITextField!
    @IBOutlet weak var workSessionGoalTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayStartDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        dayEndDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        workStartDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        workEndDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        let dayHours = AppSettings.shared.dayHours
        let workHours = AppSettings.shared.workHours
        
        let dayStart = Calendar.current.date(bySettingHour: dayHours.start.hour, minute: dayHours.start.minute, second: 0, of: Date())!
        let dayEnd = Calendar.current.date(bySettingHour: dayHours.end.hour, minute: dayHours.end.minute, second: 0, of: Date())!
        
        let workStart = Calendar.current.date(bySettingHour: workHours.start.hour, minute: dayHours.start.minute, second: 0, of: Date())!
        let workEnd = Calendar.current.date(bySettingHour: workHours.end.hour, minute: workHours.end.minute, second: 0, of: Date())!

        dayStartDatePicker.setDate(dayStart, animated: false)
        dayEndDatePicker.setDate(dayEnd, animated: false)
        workStartDatePicker.setDate(workStart, animated: false)
        workEndDatePicker.setDate(workEnd, animated: false)
        
        playSessionGoalTF.text = String(describing: AppSettings.shared.playSessionGoal)
        workSessionGoalTF.text = String(describing: AppSettings.shared.workSessionGoal)
        playSessionGoalTF.delegate = self
        workSessionGoalTF.delegate = self

        playSessionGoalTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        workSessionGoalTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)



        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == playSessionGoalTF {
            // TODO what's a sensible default for an empty input? 0 might break other parts of the app which expect a positive value
            AppSettings.shared.playSessionGoal = Int(playSessionGoalTF.text ?? "1") ?? 1
        }
        
        if textField == workSessionGoalTF {
            AppSettings.shared.workSessionGoal = Int(workSessionGoalTF.text ?? "1") ?? 1
        }
    }
    
    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        if datePicker == dayStartDatePicker {
            let hour = Calendar.current.component(.hour, from: datePicker.date)
            let minute = Calendar.current.component(.minute, from: datePicker.date)
            let startTime = Time(hour: hour, minute: minute)
            let endTime = AppSettings.shared.dayHours.end
            let hours = HourRange(type: .dayHours, start: startTime, end: endTime)
            AppSettings.shared.dayHours = hours
        }
        
        if datePicker == dayEndDatePicker {
            let hour = Calendar.current.component(.hour, from: datePicker.date)
            let minute = Calendar.current.component(.minute, from: datePicker.date)
            let startTime = AppSettings.shared.dayHours.start
            let endTime = Time(hour: hour, minute: minute)
            let hours = HourRange(type: .dayHours, start: startTime, end: endTime)
            AppSettings.shared.dayHours = hours
        }
        
        if datePicker == workStartDatePicker {
            let hour = Calendar.current.component(.hour, from: datePicker.date)
            let minute = Calendar.current.component(.minute, from: datePicker.date)
            let startTime = Time(hour: hour, minute: minute)
            let endTime = AppSettings.shared.workHours.end
            let hours = HourRange(type: .workHours, start: startTime, end: endTime)
            AppSettings.shared.workHours = hours
        }
        
        if datePicker == workEndDatePicker {
            let hour = Calendar.current.component(.hour, from: datePicker.date)
            let minute = Calendar.current.component(.minute, from: datePicker.date)
            let startTime = AppSettings.shared.dayHours.start
            let endTime = Time(hour: hour, minute: minute)
            let hours = HourRange(type: .workHours, start: startTime, end: endTime)
            AppSettings.shared.workHours = hours
        }
    }

    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

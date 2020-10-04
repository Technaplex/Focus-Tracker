//
//  ShiftsDataSource.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import UIKit

class ShiftsDataSource: NSObject {
    private var shifts = [Shift]()
    var delegate: ShiftsDataSourceDelegate?
    
    func loadShifts() {
        shifts = AppSettings.shared.shifts
    }
    
    func add(shift: Shift) {
        shifts.append(shift)
        AppSettings.shared.addShift(shift)
        delegate?.shiftValueDidChange()
    }
    
    func clear() {
        shifts = []
        AppSettings.shared.clearShifts()
        delegate?.shiftValueDidChange()
    }
}

extension ShiftsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftTableViewCell", for: indexPath) as! ShiftTableViewCell
                
        cell.activityLabel.text = shifts[indexPath.row].activity
        cell.shiftLabel.text = shifts[indexPath.row].elapsedTimeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // This may change
        return false
    }
}

// May need to be called if we implement didSelectAt/other delegate methods
extension ShiftsDataSource: UITableViewDelegate {
    
}

// May need to be called if we implement didSelectAt and want to show stuff
protocol ShiftsDataSourceDelegate: class {
    func shiftValueDidChange()
}

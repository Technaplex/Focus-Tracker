//
//  GoalTimeTableViewCell.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import UIKit

class GoalTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

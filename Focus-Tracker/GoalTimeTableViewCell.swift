//
//  GoalTimeTableViewCell.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/2/20.
//

import UIKit

class GoalTimeTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minutesLabel.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:"0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

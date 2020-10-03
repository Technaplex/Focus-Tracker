//
//  HistoryCollectionViewCell.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/3/20.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayHoursLabel: UILabel!
    @IBOutlet var workHoursLabel: UILabel!
    @IBOutlet var mindfulPlayTimeLabel: UILabel!
    @IBOutlet var mindfulWorkTimeLabel: UILabel!
    @IBOutlet var mindlessPlayTimeLabel: UILabel!
    @IBOutlet var mindlessWorkTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    var studyDay: StudyDay? {
        didSet {
            dateLabel.text = studyDay?.dayString
            dayHoursLabel.text = studyDay?.dayHoursString
            workHoursLabel.text = studyDay?.workHoursString
            mindfulPlayTimeLabel.text = studyDay?.mindfulPlayString
            mindfulWorkTimeLabel.text = studyDay?.mindfulWorkString
            mindlessPlayTimeLabel.text = studyDay?.mindlessPlayString
            mindlessWorkTimeLabel.text = studyDay?.mindlessWorkString
        }
    }
}

extension HistoryCollectionViewCell {
    func configure() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }
}

/*
 extension HistoryCollectionViewCell {
     func configure() {
         seperatorView.translatesAutoresizingMaskIntoConstraints = false
         seperatorView.backgroundColor = .lightGray
         contentView.addSubview(seperatorView)

         label.translatesAutoresizingMaskIntoConstraints = false
         label.adjustsFontForContentSizeCategory = true
         label.font = UIFont.preferredFont(forTextStyle: .body)
         contentView.addSubview(label)

         accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(accessoryImageView)

         selectedBackgroundView = UIView()
         selectedBackgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)

         let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
         let chevronImageName = rtl ? "chevron.left" : "chevron.right"
         let chevronImage = UIImage(systemName: chevronImageName)
         accessoryImageView.image = chevronImage
         accessoryImageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)

         let inset = CGFloat(10)
         NSLayoutConstraint.activate([
             label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
             label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
             label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
             label.trailingAnchor.constraint(equalTo: accessoryImageView.leadingAnchor, constant: -inset),

             accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
             accessoryImageView.widthAnchor.constraint(equalToConstant: 13),
             accessoryImageView.heightAnchor.constraint(equalToConstant: 20),
             accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),

             seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
             seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
             seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
             ])
     }
 }
 */

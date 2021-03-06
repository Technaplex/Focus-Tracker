//
//  ViewController+hideKeyboardWhenTappedAround.swift
//  Focus-Tracker
//
//  Created by Matthew Shu on 10/4/20.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

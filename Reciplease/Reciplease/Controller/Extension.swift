//
//  Extention.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension UITextField {
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0,
                                  y: frame.size.height-1,
                                  width: frame.size.width,
                                  height: 1)
        
        // I use my personalized placeHolder's color, because the bottom border both of placeHolder and bottom border are related
        bottomLine.backgroundColor = UIColor(named: "placeHolder")?.cgColor
        borderStyle = .none
        
        layer.addSublayer(bottomLine)
        
        // Add this so the layer does not go beyond the bounds of the text field
        layer.masksToBounds = true
    }
}

extension Notification.Name {
    static let ingredientsListModified = Notification.Name("ingredientsListModified")
}

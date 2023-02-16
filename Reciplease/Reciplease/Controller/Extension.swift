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

extension UITextField
{
    func addBottomBorder() {
        let bottomLine = CALayer()
        
        // The border should be inside the text field
        // so I changed frame.size.height + 5 to
        // frame.size.height - 1
        bottomLine.frame = CGRect(x: 0,
                                  y: frame.size.height-1,
                                  width: frame.size.width,
                                  height: 1)
        
        // I use the placeHolder's color, because the bottom border both of placeHolder and bottom border are related
        bottomLine.backgroundColor = UIColor(named: "placeHolder")?.cgColor
        
        //bottomLine.backgroundColor = UIColor(named: "placeHolder")?.cgColor
        /*let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "placeHolder"),
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)
        ]
        self.attributedPlaceholder = NSAttributedString(string: "Nom d'utilisateur", attributes: attributes as [NSAttributedString.Key : Any])*/
        
        
        borderStyle = .none
        
        layer.addSublayer(bottomLine)
        
        // Add this so the layer does not go beyond the
        // bounds of the text field
        layer.masksToBounds = true
    }
}

extension Notification.Name {
    static let ingredientsListModified = Notification.Name("ingredientsListModified")
}

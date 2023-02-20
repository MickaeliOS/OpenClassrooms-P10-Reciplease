//
//  SettingsViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 14/02/2023.
//

import UIKit

class SettingsViewController: UIViewController {
    enum Theme: Int {
        case unspecified
        case light
        case dark
        
        var interfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .unspecified:
                return .unspecified
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    }
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch darkmode {
        case .unspecified:
            themeSegmentedControl.selectedSegmentIndex = 0
        case .light:
            themeSegmentedControl.selectedSegmentIndex = 1
        case .dark:
            themeSegmentedControl.selectedSegmentIndex = 2
        }
        
        changeMode(mode: darkmode.interfaceStyle)
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
        
    var darkmode: Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: "darkmode")) ?? .unspecified
    }
    
    // MARK: - ACTIONS
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "darkmode")
        case 1:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "darkmode")
        case 2:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "darkmode")
        default:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "darkmode")
        }
        
        changeMode(mode: darkmode.interfaceStyle)
    }
    
    // MARK: - FUNCTIONS
    func changeMode(mode: UIUserInterfaceStyle) {
        if #available(iOS 13.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first(where: { $0.isKeyWindow })?
                .overrideUserInterfaceStyle = mode
        }
    }
    
    /*override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("mode changed")
    }*/
}

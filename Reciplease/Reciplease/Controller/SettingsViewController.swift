//
//  SettingsViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 14/02/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var darkmodeLabel: UILabel!
    @IBOutlet weak var deviceSettingsLabel: UILabel!
    @IBOutlet weak var darkmodeSwitch: UISwitch!
    @IBOutlet weak var deviceSettingsSwitch: UISwitch!
    let darkmode = UserDefaults.standard.object(forKey: "darkmode") as? Bool
    let deviceSettings = UserDefaults.standard.object(forKey: "deviceSettings") as? Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { (notification: Notification) in
            if UIApplication.shared.applicationState == .background {
                // Came from the background

                print("MODE : \(self.traitCollection.userInterfaceStyle == .dark)")

                guard let darkmode = self.darkmode, let deviceSettings = self.deviceSettings else {
                    return
                }
                
                if self.traitCollection.userInterfaceStyle == .light {
                    if darkmode && deviceSettings {
                        self.darkmodeSwitch.isOn = false
                        UserDefaults.standard.set(false, forKey: "darkmode")
                    }
                    
                } else if self.traitCollection.userInterfaceStyle == .dark {
                    if !darkmode && deviceSettings {
                        self.darkmodeSwitch.isOn = true
                        UserDefaults.standard.set(true, forKey: "darkmode")
                    }
                }
            }
        }
        
        guard let darkmode = darkmode, let deviceSettings = deviceSettings else {
            if traitCollection.userInterfaceStyle == .light {
                darkmodeSwitch.isOn = false
            }
            return
        }

        darkmodeSwitch.isOn = darkmode
        deviceSettingsSwitch.isOn = deviceSettings
    }

    @IBAction func toggleDarkmode(_ sender: UISwitch) {
        if !sender.isOn && deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .dark {
            deviceSettingsSwitch.isOn = false
            
            //TODO: Mettre en mode Light
            UserDefaults.standard.set(false, forKey: "darkmode")
            UserDefaults.standard.set(false, forKey: "deviceSettings")
            
            changeMode(mode: .light)
            return
            
        } else if !sender.isOn && !deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .dark {
            //TODO: Mettre en mode Light
            UserDefaults.standard.set(true, forKey: "darkmode")

            changeMode(mode: .light)
            return
            
        } else if sender.isOn && !deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .dark {
            //TODO: Mettre en mode Dark
            UserDefaults.standard.set(true, forKey: "darkmode")

            changeMode(mode: .dark)
            return
            
        } else if sender.isOn && deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .dark {
            //pas possible
            
        } else if sender.isOn && deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .light {
            deviceSettingsSwitch.isOn = false
            
            //TODO: Mettre en mode Dark
            UserDefaults.standard.set(true, forKey: "darkmode")
            UserDefaults.standard.set(false, forKey: "deviceSettings")

            changeMode(mode: .dark)
            return
            
        } else if !sender.isOn && !deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .light {
            //TODO: Mettre en mode Light
            UserDefaults.standard.set(false, forKey: "darkmode")

            changeMode(mode: .light)
            return
            
        } else if !sender.isOn && deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .light {
            //pas possible
            
        } else if sender.isOn && !deviceSettingsSwitch.isOn && traitCollection.userInterfaceStyle == .light {
            //TODO: Mettre en mode Dark
            UserDefaults.standard.set(true, forKey: "darkmode")

            changeMode(mode: .dark)
            return
        }
    }

    
    @IBAction func toggleDeviceSettings(_ sender: UISwitch) {
        if sender.isOn && darkmodeSwitch.isOn && traitCollection.userInterfaceStyle == .light {
            darkmodeSwitch.isOn = false
            
            //TODO: Mettre en mode Light
            UserDefaults.standard.set(false, forKey: "darkmode")
            UserDefaults.standard.set(true, forKey: "deviceSettings")
            
            changeMode(mode: .light)
        }
        
        if sender.isOn && !darkmodeSwitch.isOn && traitCollection.userInterfaceStyle == .dark {
            darkmodeSwitch.isOn = true
            
            //TODO: Mettre en mode Light
            UserDefaults.standard.set(true, forKey: "darkmode")
            UserDefaults.standard.set(true, forKey: "deviceSettings")
            
            changeMode(mode: .light)
        }
        
        print(traitCollection.userInterfaceStyle == .light)
    }

    func changeMode(mode: UIUserInterfaceStyle) {
        if #available(iOS 13.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first(where: { $0.isKeyWindow })?
                .overrideUserInterfaceStyle = mode
        }
        print("MODE : \(traitCollection.userInterfaceStyle == .dark)")
    }
    
    /*override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("mode changed")
    }*/
}

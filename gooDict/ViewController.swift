//
//  ViewController.swift
//  gooDict
//
//  Created by home on 12/02/2020.
//  Copyright © 2020 home. All rights reserved.
//
//  *************
//  ViewController is the main ViewController, starting screen.
//  Available actions:
//  - search by word or translation,
//  - random choice from base,
//  - pick up all words that start with the definite letter,
//  - add new word with translation and example.
//  *************

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var pickerFromList: UIPickerView!
    
    @IBOutlet weak var turnOnOffNotifications: UISwitch!
    var center: UNUserNotificationCenter!
    
    let defaults = UserDefaults.standard
    
    @objc func switchChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            displayMessage(textMessage: "Notifications activated. Push 10 notificatons every 30 min.", newHandler: nil)
            
            defaults.set(true, forKey: "UseBoost")
            //let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    // Handle the error here.
                }
                // Provisional authorization granted.
            }
            
            center.getDeliveredNotifications { [weak self] requests in
                guard let self = self else { return }
            }
            
            // Old notification's annihilation
            //center.removeAllDeliveredNotifications() // To remove all delivered notifications
            //center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
            
            for i in 1..<11 {
                let contentForContent = callSaveRetrieveMethod.randomChoiceForLocalNotification()
                let content = UNMutableNotificationContent()
                content.title = "\(contentForContent[0])"
                //content.badge = i as NSNumber // unavailable
                //content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1) // unavailable
                content.body = "\(contentForContent[1]) (# \(contentForContent[2]))"
                content.threadIdentifier = "gooDict identifier"
                
                let tempInterval = Double(i) * 10 * 3
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempInterval*60, repeats: false)
                
                // Create the request
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                                                    content: content,
                                                    trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            }
            
           
        } else {
            displayMessage(textMessage: "Notifications deactivated.", newHandler: nil)
            defaults.set(false, forKey: "UseBoost")
            UIApplication.shared.applicationIconBadgeNumber = 0
           
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
        }
    }
    
    var delivered: Any?
    
    var pickerData = [String]()
    let callSaveRetrieveMethod = SaveRetrieveFunctions()
    
    override func viewDidAppear(_ animated: Bool) {
        // turnOnOffNotifications.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        turnOnOffNotifications.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        defaults.bool(forKey: "UseBoost") ? turnOnOffNotifications.setOn(true, animated: true) : turnOnOffNotifications.setOn(false, animated: true)
      
        center = UNUserNotificationCenter.current()
        
        navigationController?.navigationBar.isHidden = true
        if callSaveRetrieveMethod.setWords.count > 0 {
            totalAmount.text = String(callSaveRetrieveMethod.setWords.count)
        } else { totalAmount.text = "0" }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        pickerData = ["A", "B", "C", "D", "E", "F", "G", "H", "I",
                      "J", "K", "L", "M", "N", "O", "P", "Q", "R",
                      "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        self.pickerFromList.delegate = self
        self.pickerFromList.dataSource = self
        self.hideKeyboard()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "searchSegue":
            if CoreDataEntityValidationManager.shared.dataEntityIsEmpty {
                displayMessage(textMessage: "Error (no data)", newHandler: nil)
                return false
            } else {
                if searchField.text!.isEmpty {
                    displayMessage(textMessage: "Searching request is empty. Please type anything.",
                                   newHandler: nil)
                    return false
                } else {
                    if callSaveRetrieveMethod.searchInArrays(searchedWord: searchField.text!) {
                        return true
                    } else {
                        //displayMessage(textMessage: "Nothing found", newHandler: nil)
                        
                        let alert = UIAlertController(title: "Message", message: "Nothing found in the dictionary.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Got it.", style: .cancel, handler: nil)
                        let action1 = UIAlertAction(title: "Add as a new?", style: .default, handler: {action in useAsANewWord(alert: action) })
                        alert.addAction(action)
                        alert.addAction(action1)
                        present(alert, animated: true, completion: nil)
                        
                        func useAsANewWord(alert: UIAlertAction!) {
                            
                            if let vc = storyboard?.instantiateViewController(withIdentifier: "addNewVC") as? AddNewViewController {
                                
                                vc.detailWord = searchField.text!

                                navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            
                        }
                        
                        return false
                    }
                }
            }
        case "randomSegue":
            if CoreDataEntityValidationManager.shared.dataEntityIsEmpty {
                displayMessage(textMessage: "Error (no data)", newHandler: nil)
                return false
            } else {
                callSaveRetrieveMethod.randomInArrays()
                return true
            }
        case "addSegue":
            return true
        default:
            displayMessage(textMessage: "Nothing found", newHandler: nil)
            return false
        }
    }
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Number of columns with data
        return 1
    }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Numbers of rows
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchField.text = pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}

extension UIViewController {
    
    func displayMessage(textMessage: String, newHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Message", message: textMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: newHandler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

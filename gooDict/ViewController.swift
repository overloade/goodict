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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var pickerFromList: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    let callSaveRetrieveMethod = SaveRetrieveFunctions()
    
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
                        displayMessage(textMessage: "Nothing found", newHandler: nil)
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

    override func viewWillAppear(_ animated: Bool) {
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
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

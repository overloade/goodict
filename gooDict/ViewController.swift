//
//  ViewController.swift
//  gooDict
//
//  Created by home on 12/02/2020.
//  Copyright © 2020 home. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var pickerFromList: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           if (CoreDataEntityValidationManager.shared.bankEntityIsEmpty && identifier == "searchSegue") || (CoreDataEntityValidationManager.shared.bankEntityIsEmpty && identifier == "randomSegue") {
                let message = "Error. No data"
                let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return false
           } else if identifier == "searchSegue" {
                if searchField.text!.isEmpty {
                    let message = "Search request is empty. Please type anything."
                    let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                    return false
                } else {
                    let callSaveRetrieveMethod = SaveRetrieveFunctions()
                    
                    if callSaveRetrieveMethod.searchInArrays(searchedWord: searchField.text!) {
                        return true
                    } else {
                        let message = "Nothing found"
                        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
                        return false
                    }
                }
           } else if identifier == "addSegue" {
                return true
           } else if identifier == "randomSegue" {
                let callSaveRetrieveMethod = SaveRetrieveFunctions()
                callSaveRetrieveMethod.randomInArrays()
                return true
           } else {
                let message = "Nothing found."
                let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return false
        }
    }

    func countTheTotalNumber() -> String {
        let callSaveRetrieveMethod = SaveRetrieveFunctions()
        let setWordsCount = callSaveRetrieveMethod.setWords.count
        if setWordsCount > 0 { totalAmount.text = String(setWordsCount) }
        print("bad boys bad boys what we gotta do")
        return totalAmount.text!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        countTheTotalNumber()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
        "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
        "W", "X", "Y", "Z"]

        self.pickerFromList.delegate = self
        self.pickerFromList.dataSource = self
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

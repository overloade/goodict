//
//  addNewControllerView.swift
//  gooDict
//
//  Created by home on 12/02/2020.
//  Copyright © 2020 home. All rights reserved.
//
//  *************
//  AddViewController is used for ADD and EDIT actions on given word.
//  *************

import Foundation
import UIKit
import CoreData

class AddNewViewController: UIViewController, UITextViewDelegate {
    
    let callSaveRetrieveMethod = SaveRetrieveFunctions()
    var shouldBeEdited = false // checker: if AddNewViewController was called on from DeteiledInfoVC
                               // and should trigger "Editing" scenario instead of "Adding"
   
    @IBOutlet weak var wordView: UITextView!
    @IBOutlet weak var trView: UITextView!
    @IBOutlet weak var exView: UITextView!
    
    var detailWord: String = "" // got from DetailedInfoViewController
    var detailTranslation: String = "" // got from DetailedInfoViewController
    var detailExample: String = "" // got from DetailedInfoViewController
    
    var editedWord: String = ""
    var editedTranslation: String = ""
    var editedExample: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.isHidden = false
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        self.wordView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.trView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.exView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
 
        self.wordView.delegate = self
        self.trView.delegate = self
        self.exView.delegate = self
 
        wordView.isScrollEnabled = false
        trView.isScrollEnabled = false
        exView.isScrollEnabled = false
 
        wordView.layer.cornerRadius = 10
        trView.layer.cornerRadius = 10
        exView.layer.cornerRadius = 10
        
        wordView.text = detailWord
        trView.text = detailTranslation
        exView.text = detailExample
 
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    
        // Check if wordView & trView & exView were prefilled from DetailedInfoVC and it should trigger "Editing" action
        if !wordView.text!.isEmpty && !trView.text!.isEmpty && !exView.text!.isEmpty {
            shouldBeEdited = true
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
     
        if let userInfo = notification.userInfo,
           let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/2.3)
            }
        }
        
        /*
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/2)
            }
        }
        */
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight = UIScreen.main.bounds.height - 20 // was 20
        let fixedWidth = textView.frame.size.width
        
        wordView.frame.size = wordView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
        wordView.center = view.center
        trView.frame.size = trView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
        trView.center = view.center
        exView.frame.size = exView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
        exView.center = view.center
    }
 
    @IBAction func addNewButton(_ sender: UIButton) {
        editedWord = wordView.text!
        editedTranslation = trView.text!
        editedExample = exView.text!
        
        if wordView.text!.isEmpty || trView.text!.isEmpty || exView.text!.isEmpty {
            displayMessage(textMessage: "One of the strings is empty. Please, fill in all fields.",                             newHandler: nil)
        } else { shouldBeEdited ? editData() : addNewData() }
    }
    
    func returnToStartingScreen(alert: UIAlertAction!) {
        let vc = self.storyboard?.instantiateViewController(identifier: "returnToStartingScreen") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editData() {
        callSaveRetrieveMethod.editInArrays(oldWord: detailWord,
                                            oldTranslation: detailTranslation,
                                            oldExample: detailExample,
                                            newWord: editedWord,
                                            newTranslation: editedTranslation,
                                            newExample: editedExample) ?
            displayMessage(textMessage: "Successfully edited.", newHandler: returnToStartingScreen) : displayMessage(textMessage: "Error occured.", newHandler: nil)
    }
        
    func addNewData() {
        if callSaveRetrieveMethod.setWords.contains(wordView.text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
            displayMessage(textMessage: "Word has already been found in the dictionary. Please, correct the word or mark it with (2), (3), (4) tag.", newHandler: nil)
        } else {
            callSaveRetrieveMethod.addInArrays(newWord: wordView.text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), newTranslation: trView.text, newExample: exView.text) ? displayMessage(textMessage: "Successfully added.", newHandler: returnToStartingScreen) : displayMessage(textMessage: "Error occured.", newHandler: returnToStartingScreen)
        }
    }
}

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

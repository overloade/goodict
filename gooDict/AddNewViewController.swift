//
//  addNewControllerView.swift
//  gooDict
//
//  Created by home on 12/02/2020.
//  Copyright © 2020 home. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class AddNewViewController: UIViewController, UITextViewDelegate {
   
    @IBOutlet weak var wordView: UITextView!
    @IBOutlet weak var trView: UITextView!
    @IBOutlet weak var exView: UITextView!
    
    var detailWord: String = "" // edited Word string
    var detailTranslation: String = "" // edited Translation string
    var detailExample: String = "" // edited Example string
    
    var editedWord: String = ""
    var editedTranslation: String = ""
    var editedExample: String = ""
    
    var checkEditOrAdd: Bool = true // checker
    
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.isHidden = false
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
   
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        if wordView.text!.isEmpty && trView.text!.isEmpty && exView.text!.isEmpty {
            checkEditOrAdd = false
        } else {
            return
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/2)
            }
        }
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
        let maxHeight = UIScreen.main.bounds.height - 40 // was 20
        let fixedWidth = textView.frame.size.width
        let wordViewNewSize = wordView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
        let trViewNewSize = trView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
        let exViewNewSize = exView.sizeThatFits(CGSize(width: fixedWidth, height: maxHeight))
 
        wordView.frame.size = wordViewNewSize
        wordView.center = view.center
        trView.frame.size = trViewNewSize
        trView.center = view.center
        exView.frame.size = exViewNewSize
        exView.center = view.center
    }
    
    var previousPosition:CGRect = CGRect.zero
 
    @IBAction func addNewButton(_ sender: UIButton) {
        editedWord = wordView.text!
        editedTranslation = trView.text!
        editedExample = exView.text!

        checkEditOrAdd ? editData() : addNewData()
     }
    
    func editData() {
        let callSaveRetrieveMethod = SaveRetrieveFunctions()
        if callSaveRetrieveMethod.editInArrays(word: detailWord, translation: detailTranslation, example: detailExample, newWord: editedWord,  newTranslation: editedTranslation, newExample: editedExample) {
            let message = "Successfully edited."
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            wordView.text?.removeAll()
            exView.text?.removeAll()
            trView.text?.removeAll()
        }
    }
    
    func addNewData() {
        let newAddedWord = wordView.text!
        let newAddedTranslation = trView.text!
        let newAddedExample = exView.text!
            
        if newAddedWord.isEmpty || newAddedTranslation.isEmpty || newAddedExample.isEmpty  {
            let message = "One of the strings is empty. Please fill all fields."
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let callSaveRetrieveMethod = SaveRetrieveFunctions()
            if callSaveRetrieveMethod.addInArrays(word: newAddedWord, translation: newAddedTranslation, example: newAddedExample) {
                let message = "Successful."
                let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                wordView.text?.removeAll()
                exView.text?.removeAll()
                trView.text?.removeAll()
            }
        }
    }
}

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

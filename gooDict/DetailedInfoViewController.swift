//
//  DetailedInfoViewController.swift
//  gooDict
//
//  Created by home on 01/03/2020.
//  Copyright © 2020 home. All rights reserved.
//
import Foundation
import UIKit

class DetailedInfoViewController: UIViewController {
        
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "popUpVC") as! PopUpViewController
        popOverVC.popUpWord = detailWord
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @IBOutlet weak var labelWord: UILabel!
    @IBOutlet weak var labelTranslation: UILabel!
    @IBOutlet weak var labelExample: UILabel!
    
    
    
    var detailWord: String = ""
    var detailTranslation: String = ""
    var detailExample: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.isHidden = false
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelWord.sizeToFit()
        labelTranslation.sizeToFit()
        labelExample.sizeToFit()
        
        labelWord.text = detailWord
        labelTranslation.text = detailTranslation
        labelExample.text = detailExample
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "editItemSegue" {
            let destinationVC:AddNewViewController = segue.destination as! AddNewViewController
            destinationVC.detailWord = detailWord
            destinationVC.detailTranslation = detailTranslation
            destinationVC.detailExample = detailExample
        }
    }
}

/*
extension UIViewController {
    func showSpinner(onView : UIView) {
           let spinnerView = UIView.init(frame: onView.bounds)
           spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
           let ai = UIActivityIndicatorView.init(style: .large)
           ai.startAnimating()
           ai.center = spinnerView.center
           
           DispatchQueue.main.async {
               spinnerView.addSubview(ai)
               onView.addSubview(spinnerView)
           }
           
           self.vSpinner = spinnerView
       }

       func removeSpinner() {
           DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
           }
       }
}
*/

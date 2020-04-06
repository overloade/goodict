//
//  DetailedInfoViewController.swift
//  gooDict
//
//  Created by home on 01/03/2020.
//  Copyright © 2020 home. All rights reserved.
//
//  *************
//  Separate ViewController that shows full text of word, translation, example fields for definite word.
//  *************

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
        
        labelWord.sizeToFit()
        labelTranslation.sizeToFit()
        labelExample.sizeToFit()
        
        labelWord.text = detailWord
        labelTranslation.text = detailTranslation
        labelExample.text = detailExample
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

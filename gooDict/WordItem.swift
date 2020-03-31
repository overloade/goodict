//
//  wordItem.swift
//  gooDict
//
//  Created by home on 22/02/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

class WordItem: NSObject {
    
    @objc var textWord = ""
    @objc var textTranslation = ""
    @objc var textExample = ""
    
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
    

}

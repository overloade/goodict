//
//  getWords.swift
//  gooDict
//
//  Created by home on 22/02/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// purpose: fetch the words from CoreData base EngDict, keep them.
class GetWordsList {
    
    static var rowArray = [WordItem]()
    
    func getTheRowArray(rowGottenArray: [WordItem]) {
        GetWordsList.rowArray = rowGottenArray
    }
        
    func returnTheRowArray() -> [WordItem] {
        return GetWordsList.rowArray
    }
    
    func removeItem(passedItem: WordItem, at index: Int) {
        GetWordsList.rowArray.remove(at: index)
    }
        
}

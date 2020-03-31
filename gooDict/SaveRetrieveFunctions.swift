//
//  SaveRetrieveFunctions.swift
//  gooDict
//
//  Created by home on 26/02/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SaveRetrieveFunctions {
    
    var setWords: [String] = []
    var setExamples: [String] = []
    var setTranslations: [String] = []
    var getWord: GetWordsList = GetWordsList()
    
    init() {
        // deleteAllData()
        let receivedData = retrieveData()
        setWords = receivedData.words
        setExamples = receivedData.examples
        setTranslations = receivedData.translations
        
        self.backup(backupName: "third_backup")
        print("Document Directory is: ", getDocumentsDirectory())
    }
    
    func makeRowsArray(setStandardWords: [String], setStandardExamples: [String], setStandardTranslations: [String]) -> [WordItem] {
        var rowArray: [WordItem] = []
        
        if setStandardWords.count > 0 {
            for i in 0...setStandardWords.count-1 {
                let row = WordItem()
                row.textWord = setStandardWords[i]
                row.textExample = setStandardExamples[i]
                row.textTranslation = setStandardTranslations[i]
                rowArray.append(row)
            }
        } else {
                
        }
        print("something")
        print("anything")
        print("things are gone")
        print("do or not do")
        return(rowArray)
    }
        
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // backup function
    func backup(backupName: String){
        print("Starting backup")
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })

        let store:NSPersistentStore = container.persistentStoreCoordinator.persistentStores.last!
        do {
            try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
            print("Backup finished")
        } catch {
            print("Failed to migrate")
        }
    }
    
    // restore from backup
    
    func restoreFromStore(backupName: String){

        // print(DatabaseHelper.shareInstance.getAllUsers())
        let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let storeUrl = storeFolderUrl.appendingPathComponent("gooDict.sqlite")
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")

        let container = NSPersistentContainer(name: "gooDict")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let stores = container.persistentStoreCoordinator.persistentStores

            for store in stores {
                print(store)
                print(container)
            }
            do{
                try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl,sourceOptions: nil,ofType: NSSQLiteStoreType)
                // print(DatabaseHelper.shareInstance.getAllUsers())
            } catch {
                print("Failed to restore")
            }

        })

    }
    
    
    // Don't use it. Service function.
    func deleteAllData() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EngDict")
        
        do {
            let arrUsrObj = try managedContext.fetch(fetchRequest)
            for usrObj in arrUsrObj as! [NSManagedObject] {
                managedContext.delete(usrObj)
            }
        try managedContext.save() //don't forget
            } catch let error as NSError {
                print("delete fail--",error)
            }
        print("successfully deleted")
    }
 
    // Experimental method created for the deleting one definite row in table view controller
    func deleteOnlyOneRow(wordForDeleting: String) {
         let appDelegate = UIApplication.shared.delegate as? AppDelegate
         let managedContext = appDelegate!.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EngDict")
         
         do {
             let arrUsrObj = try managedContext.fetch(fetchRequest)
             
             let objectToDelete = arrUsrObj[0] as! NSManagedObject
             managedContext.delete(objectToDelete)
            
             try managedContext.save() //don't forget
          
          } catch let error as NSError {
                print("delete fail--", error)
          }
        
         print("successfully deleted")
    
    }
    
    func searchInArrays(searchedWord: String) -> Bool {
        // let searchingWord: String = searchedWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        var newWords: [String] = []
        var newExamples: [String] = []
        var newTranslations: [String] = []
        var checker: Bool = true
        
        if searchedWord.count == 1 && { () -> Bool in return(Character(searchedWord).isUppercase) }() {
                for i in 0...setWords.count-1 {
                    if setWords[i].prefix(1).contains(searchedWord.lowercased()) || setWords[i].prefix(1).contains(searchedWord.uppercased()) {
                        newWords.append(setWords[i])
                        newExamples.append(setExamples[i])
                        newTranslations.append(setTranslations[i])
                    }
                }
                if newWords.count < 1 { checker = false }
        } else {
            for i in 0...setWords.count-1 {
                let searchingWord = searchedWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
                if setWords[i].contains(searchingWord) || setExamples[i].contains(searchingWord) {
                    newWords.append(setWords[i])
                    newExamples.append(setExamples[i])
                    newTranslations.append(setTranslations[i])
                }
            }
            if newWords.count < 1 { checker = false }
        }
        
        let finishedArray: [WordItem] = makeRowsArray(setStandardWords: newWords, setStandardExamples: newExamples, setStandardTranslations: newTranslations)
        
        getWord.getTheRowArray(rowGottenArray: finishedArray)

        return checker
    }
        
    func randomInArrays() {
        let randomInt = Int.random(in: 0...setWords.count-1)
        let newWord: [String] = [setWords[randomInt]]
        let newExample: [String] = [setExamples[randomInt]]
        let newTranslation: [String] = [setTranslations[randomInt]]
        
        let finishedArray: [WordItem] = makeRowsArray(setStandardWords: newWord, setStandardExamples: newExample, setStandardTranslations: newTranslation)
    
        getWord.getTheRowArray(rowGottenArray: finishedArray)
    }
    
    func addInArrays(word: String, translation: String, example: String) -> Bool {
        var nWord: String = word
        var nTranslation: String = translation
        var nExample: String = example
        
        func searchInArraysForDuplicate(addedWord: String) {
            
            let soughtWord: String = addedWord
            
            if setWords.count > 1 {
                for i in 0...setWords.count-1 {
                   // Experimental version. Should be realized with a substring
                   if setWords[i].contains(soughtWord) {
                       break
                   }
                   else {
                       serviceAddInArray(addingWord: nWord, addingTranslation: nTranslation, addingExample: nExample)
                       break
                   }
                }
            } else { serviceAddInArray(addingWord: nWord, addingTranslation: nTranslation, addingExample: nExample) }
        }
        
        searchInArraysForDuplicate(addedWord: nWord)
        return true
    }
    
    func editInArrays(word: String, translation: String, example: String,
                      newWord: String, newTranslation: String, newExample: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchReqeust = NSFetchRequest<NSFetchRequestResult>(entityName: "EngDict")

        do {
            let test = try managedContext.fetch(fetchReqeust)
            
            for data in test as! [NSManagedObject] {
            //for i in 0...test.count-1 {
                if data.value(forKey: "word") as! String == word &&
                    data.value(forKey: "translation") as! String == translation &&
                    data.value(forKey: "example") as! String == example {
                        // let objectUpdate = data as! NSManagedObject
                        data.setValue(newWord, forKey: "word")
                        data.setValue(newTranslation, forKey: "translation")
                        data.setValue(newExample, forKey: "example")
                        break
                }
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        } catch {
            print("Failed")
        }
        
        return true
    }
    
    func serviceAddInArray(addingWord: String, addingTranslation: String, addingExample: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "EngDict", in: managedContext)!

        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(addingWord, forKey: "word")
        user.setValue(addingTranslation, forKey: "translation")
        user.setValue(addingExample, forKey: "example")
 
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }

    
    // Establishing the connection, get the data from the CoreData base.
    
    func retrieveData() -> (words: [String], examples: [String], translations: [String]) {
        // var newData: Any?
        // guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [Any]?.self }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchReqeust = NSFetchRequest<NSFetchRequestResult>(entityName: "EngDict")
        
        var newWords: [String] = []
        var newExamples: [String] = []
        var newTranslation: [String] = []
        
        do {
            let result = try managedContext.fetch(fetchReqeust)
            
            // deleteAllData()
            
            for data in result as! [NSManagedObject] {
                newWords.append(data.value(forKey: "word") as! String)
                newExamples.append(data.value(forKey: "example") as! String)
                newTranslation.append(data.value(forKey: "translation") as! String)
            }
            
        } catch {
            print("Failed")
        }
        
        return(words: newWords, examples: newExamples, translations: newTranslation)
    }
    
    
}

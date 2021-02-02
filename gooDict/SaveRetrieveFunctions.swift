//
//  SaveRetrieveFunctions.swift
//  gooDict
//
//  Created by home on 26/02/2020.
//  Copyright © 2020 home. All rights reserved.
//
//  *************
//  There are bunch of service functions used for perform any (add, edit, delete, fetch, and so on) actions.
//  *************
import Foundation
import CoreData
import UIKit

class SaveRetrieveFunctions {
    /* Establishing connection with CoreData */
    let managedContext = CoreDataManager.shared.context
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EngDict")
    
    var setWords: [String] = [] // Array for Words
    var setTranslations: [String] = [] // Array for Translations
    var setExamples: [String] = [] // Array for Examples
    
    static var rowArray = [WordItem]()
    static var isRandomMethodWasCalled = false // variable using for refresing purpuse in TVC
        
    init() {
        // deleteAllData()
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                setWords.append(data.value(forKey: "word") as! String)
                setTranslations.append(data.value(forKey: "translation") as! String)
                setExamples.append(data.value(forKey: "example") as! String)
            }
        } catch { print("Failed") }
        // self.backup(backupName: "third_backup")
        // print("Document Directory is: ", getDocumentsDirectory())
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
    
    func restoreFromStore(backupName: String) {

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
            do {
                try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl,sourceOptions: nil,ofType: NSSQLiteStoreType)
                // print(DatabaseHelper.shareInstance.getAllUsers())
            } catch {
                print("Failed to restore")
            }

        })

    }

    // Don't use it. Service function
    func deleteAllData() {
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
         do {
             let arrUsrObj = try managedContext.fetch(fetchRequest)
             
             let objectToDelete = arrUsrObj[0] as! NSManagedObject
             managedContext.delete(objectToDelete)
            
             try managedContext.save() //don't forget
          
          } catch let error as NSError { print("delete fail--", error) }
        
         print("successfully deleted")
    }
    
    func searchInArrays(searchedWord: String) -> Bool {
        var checker = true
        SaveRetrieveFunctions.rowArray.removeAll()
        
        if searchedWord.count == 1 && { () -> Bool in return(Character(searchedWord).isUppercase) }() {
                for i in 0...setWords.count-1 {
                    if setWords[i].prefix(1).contains(searchedWord.lowercased()) || setWords[i].prefix(1).contains(searchedWord.uppercased()) {
                        let row = WordItem()
                        row.textWord = setWords[i]
                        row.textTranslation = setTranslations[i]
                        row.textExample = setExamples[i]
                        SaveRetrieveFunctions.rowArray.append(row)
                    }
                }
            if SaveRetrieveFunctions.rowArray.count < 1 { checker = false }
        } else {
            for i in 0...setWords.count-1 {
                let searchingWord = searchedWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                if setWords[i].contains(searchingWord) || setExamples[i].contains(searchingWord) {
                    let row = WordItem()
                    row.textWord = setWords[i]
                    row.textTranslation = setTranslations[i]
                    row.textExample = setExamples[i]
                    SaveRetrieveFunctions.rowArray.append(row)
                }
            }
            if SaveRetrieveFunctions.rowArray.count < 1 { checker = false }
        }
        return checker
    }
    
    func giveRowToTableView() -> [WordItem] {
        return SaveRetrieveFunctions.rowArray
    }
    
    func removeItem(passedItem: WordItem, at index: Int) {
        SaveRetrieveFunctions.rowArray.remove(at: index)
    }
    
    func randomInArrays() {
        SaveRetrieveFunctions.rowArray.removeAll()
        
        let randomInt = Int.random(in: 0...setWords.count-1)
        let row = WordItem()
        row.textWord = setWords[randomInt]
        row.textExample = setExamples[randomInt]
        row.textTranslation = setTranslations[randomInt]
        
        SaveRetrieveFunctions.rowArray.append(row)
        SaveRetrieveFunctions.isRandomMethodWasCalled = true // for refreshing purpose
    }
    
    func randomChoiceForLocalNotification() -> [String] {
        
        var tempArray: [String] = []
        let randomInt = Int.random(in: 0...setWords.count-1)
        
        //print("setWords count = ", setWords.count)
        
        tempArray.append(setWords[randomInt])
        tempArray.append(setTranslations[randomInt])
        tempArray.append(setExamples[randomInt])
      
        return tempArray
    }
    
    func addInArrays(newWord: String, newTranslation: String, newExample: String) -> Bool {
        do {
            let userEntity = NSEntityDescription.entity(forEntityName: "EngDict", in: managedContext)!
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            user.setValue(newWord, forKey: "word")
            user.setValue(newTranslation, forKey: "translation")
            user.setValue(newExample, forKey: "example")
        
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return false
            }
        } catch {
            print("Failed")
            return false
        }
        return true
    }
        
    func editInArrays(oldWord: String, oldTranslation: String, oldExample: String,
                      newWord: String, newTranslation: String, newExample: String) -> Bool {
        do {
            let attempt = try managedContext.fetch(fetchRequest)
            for data in attempt as! [NSManagedObject] {
                if data.value(forKey: "word") as! String == oldWord &&
                   data.value(forKey: "translation") as! String == oldTranslation &&
                   data.value(forKey: "example") as! String == oldExample {
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
                return false
            }
            
        } catch {
            print("Failed")
            return false
        }
        return true
    }
}

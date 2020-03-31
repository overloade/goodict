//
//  tableViewController.swift
//  gooDict
//
//  Created by home on 12/02/2020.
//  Copyright © 2020 home. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var detailedWord = ""
    var detailedTranslation = ""
    var detailedExample = ""

    var getWords: GetWordsList
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        getWords = GetWordsList()
        super.init(coder: aDecoder)
    }
    
    /*
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Accessory btn tapped")
    }
    */

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let item = getWords.returnTheRowArray()[indexPath.row]
            getWords.removeItem(passedItem: item, at: indexPath.row)
            let indexPaths = [indexPath]
            //tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate!.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EngDict")
             
            do {
                let arrUsrObj = try managedContext.fetch(fetchRequest)
                let objectToDelete = arrUsrObj[indexPath.row] as! NSManagedObject
                managedContext.delete(objectToDelete)
                try managedContext.save()
            } catch let error as NSError {
                print("delete fail--", error)
            }
            
            tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
            
            /*
            self.tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .top)
            tableView.reloadData()
            self.tableView.endUpdates()
            */
            
            /*
            let commit = commits[indexPath.row]
            container.viewContext.delete(commit)
            commits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            saveContext()
            */
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Worditem", for: indexPath) as! TableViewCell
        //cell.editingAccessoryType = .detailButton
        let items = getWords.returnTheRowArray()
        let item = items[indexPath.row]
        configureWord(for: cell, with: item)
        // detailedWord = cell.wordDict.text!
        // detailedExample = cell.exampleDict.text!
        // detailedTranslation = cell.translationDict.text!
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getWords.returnTheRowArray().count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
        // if let cell = tableView.cellForRow(at: indexPath) {
            let items = getWords.returnTheRowArray()
            let item = items[indexPath.row]
            detailedWord = item.textWord
            detailedTranslation = item.textTranslation
            detailedExample = item.textExample
            
            let vc = storyboard?.instantiateViewController(identifier: "searchDetailsSegue") as! DetailedInfoViewController
            vc.detailWord = detailedWord
            vc.detailTranslation = detailedTranslation
            vc.detailExample = detailedExample
            
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchDetailsSegue") {
            let destinationVC:DetailedInfoViewController = segue.destination as! DetailedInfoViewController
            print("detailedWord from func prepare() = \(detailedWord), and \(detailedExample) and \(detailedTranslation)")
            destinationVC.detailWord = detailedWord
            destinationVC.detailExample = detailedExample
            destinationVC.detailTranslation = detailedTranslation
        }
        else { return }
    }
    */

    func configureWord(for cell: UITableViewCell, with item: WordItem) {
          if let checkmarkCell = cell as? TableViewCell {
            checkmarkCell.wordDict.text = item.textWord
            checkmarkCell.translationDict.text = item.textTranslation
            checkmarkCell.exampleDict.text = item.textExample
          }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // Make the first row larger to accommodate a custom cell.
        if indexPath.row >= 0 {
            return 100
        }

        // Use the default size for all other rows.
        return UITableView.automaticDimension
    }
}

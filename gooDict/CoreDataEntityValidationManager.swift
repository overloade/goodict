//
//  CoreDataEntityValidationManager.swift
//  gooDict
//
//  Created by home on 01/03/2020.
//  Copyright © 2020 home. All rights reserved.
//

import CoreData

class CoreDataEntityValidationManager {
    
    static let shared = CoreDataEntityValidationManager()
    private init(){}
    
    var bankEntityIsEmpty: Bool {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EngDict")
            let count = try CoreDataManager.shared.context.count(for: fetchRequest)
            return count == 0 ? true : false
        } catch {
            return true
        }
    }
    
}

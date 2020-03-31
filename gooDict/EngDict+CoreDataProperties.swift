//
//  EngDict+CoreDataProperties.swift
//  gooDict
//
//  Created by home on 20/02/2020.
//  Copyright © 2020 home. All rights reserved.
//
//

import Foundation
import CoreData


extension EngDict {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EngDict> {
        return NSFetchRequest<EngDict>(entityName: "EngDict")
    }

    @NSManaged public var example: String?
    @NSManaged public var translation: String?
    @NSManaged public var word: String?

}

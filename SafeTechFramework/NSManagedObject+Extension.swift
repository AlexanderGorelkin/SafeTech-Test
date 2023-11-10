//
//  NSManagedObject+Extension.swift
//  SafeTechFramework
//
//  Created by Александр Горелкин on 10.11.2023.
//

import Foundation
import CoreData

public extension NSManagedObject {
  convenience init(using usedContext: NSManagedObjectContext) {
    let name = String(describing: type(of: self))
    let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
    self.init(entity: entity, insertInto: usedContext)
  }
}

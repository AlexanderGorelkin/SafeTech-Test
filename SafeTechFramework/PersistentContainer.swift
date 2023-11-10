//
//  PersistentContainer.swift
//  SafeTechFramework
//
//  Created by Александр Горелкин on 10.11.2023.
//

import Foundation
import CoreData
class PersistentContainer: NSPersistentContainer { }



lazy var container: PersistentContainer = {
    let result = PersistentContainer(name: "Your xcdatamodeld file name here")
    result.loadPersistentStores { (storeDescription, error) in
        if let error = error {
            print(error.localizedDescription)
        }
    }
    return result
}()

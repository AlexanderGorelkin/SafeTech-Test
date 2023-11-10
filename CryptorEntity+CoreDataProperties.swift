//
//  CryptorEntity+CoreDataProperties.swift
//  SafeTechFramework
//
//  Created by Александр Горелкин on 10.11.2023.
//
//

import Foundation
import CoreData


extension CryptorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CryptorEntity> {
        return NSFetchRequest<CryptorEntity>(entityName: "CryptorEntity")
    }

    @NSManaged public var dataString: String?

}

extension CryptorEntity : Identifiable {

}

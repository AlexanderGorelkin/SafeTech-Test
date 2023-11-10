//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Александр Горелкин on 24.10.2023.
//

import Foundation
import CoreData
import CryptoKit

class PersistentContainer: NSPersistentContainer { }

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    private let entityName: String = "CryptorEntity"
    var savedEntities: [CryptorEntity] = []
    private lazy var container: PersistentContainer = {
        let result = PersistentContainer(name: "CryptorContainer2")
        result.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return result
    }()
    func deleteall(){
        let request = NSFetchRequest<CryptorEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
            for c in savedEntities{
                container.viewContext.delete(c)
            }
        } catch(let error) {
            print("Error fetching portfolio entity \(error.localizedDescription)")
        }
        save()
    }
    
    // MARK:  PUBLIC
    func updatePortfolio(dataString: Data?) {
        guard let dataString = dataString else { return }
       
        let entity = CryptorEntity(using: container.viewContext)
        entity.dataString = dataString
        applyChanges()
        
    }
    
    
    // MARK:  PRIVATE
    private func getPortfolio() {
        
        let request = NSFetchRequest<CryptorEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch(let error) {
            print("Error fetching portfolio entity \(error.localizedDescription)")
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch(let error) {
            print("Error saving to Core Data: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
    
}

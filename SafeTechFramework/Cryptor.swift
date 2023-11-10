//
//  Cryptor.swift
//  SafeTechFramework
//
//  Created by Александр Горелкин on 10.11.2023.
//

import Foundation
import Security


public final class Cryptor {
   

    
    
    
    
    /// Возвращает список расшифрованных записей из базы данных
    public static var strings: [String] {
        get async {
            return CoreDataManager.shared.savedEntities.map {
                try! AsymmetricCrypto.shared.decryptData(encryptedData: $0.dataString!) ?? ""
            }
        }
    }
    /// Шифрует переданную строку и сохраняет её в базу данных
    public static func store(string: String) async throws {
        let data = try? AsymmetricCrypto.shared.encryptString(message: string)
        CoreDataManager.shared.updatePortfolio(dataString: data)
    }
    
    
    

    
}

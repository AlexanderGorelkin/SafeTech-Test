//
//  Cryptor.swift
//  SafeTechFramework
//
//  Created by Александр Горелкин on 10.11.2023.
//

import Foundation


public final class Cryptor {
    /// Возвращает список расшифрованных записей из базы данных
    public static var strings: [String] {
        get async {
            return CoreDataManager.shared.savedEntities.map { $0.dataString ?? "" }
        }
    }
    /// Шифрует переданную строку и сохраняет её в базу данных
    public static func store(string: String) async throws {
        CoreDataManager.shared.updatePortfolio(dataString: string)
    }
}

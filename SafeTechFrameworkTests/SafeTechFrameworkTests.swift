//
//  SafeTechFrameworkTests.swift
//  SafeTechFrameworkTests
//
//  Created by Александр Горелкин on 10.11.2023.
//

import XCTest
@testable import SafeTechFramework

final class SafeTechFrameworkTests: XCTestCase {
    func testExample() async throws {
        DispatchQueue.global().sync {
            CoreDataManager.shared.deleteall()
        }
        let inputStrings = (0..<100).map { _ in UUID().uuidString }
        for inputString in inputStrings {
            try? await Cryptor.store(string: inputString)
        }
        let storedStrings = await Cryptor.strings
//        print("inputStrings: \(inputStrings)")
//        print("storedStrings: \(storedStrings)")

        XCTAssertEqual(inputStrings, storedStrings)
    }
}

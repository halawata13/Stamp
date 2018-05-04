//
//  DateTests.swift
//

import Foundation
import XCTest
@testable import Stamp

class DateTests: XCTestCase {
    func testsAt0() {
        let date = Date()
        let dateAt0 = date.at0!
        let calendar = Calendar(identifier: .gregorian)

        XCTAssertEqual(calendar.component(.year, from: date), calendar.component(.year, from: dateAt0))
        XCTAssertEqual(calendar.component(.month, from: date), calendar.component(.month, from: dateAt0))
        XCTAssertEqual(calendar.component(.day, from: date), calendar.component(.day, from: dateAt0))
        XCTAssertEqual(0, calendar.component(.hour, from: dateAt0))
        XCTAssertEqual(0, calendar.component(.minute, from: dateAt0))
        XCTAssertEqual(0, calendar.component(.second, from: dateAt0))
    }
}

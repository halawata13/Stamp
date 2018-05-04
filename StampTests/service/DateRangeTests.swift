//
//  DateRangeTests.swift
//

import XCTest
import Foundation
@testable import Stamp

class DateRangeTests: XCTestCase {

    var dateRangeService: DateRangeService!
    
    override func setUp() {
        super.setUp()

        dateRangeService = DateRangeService()

        UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_save_and_load() {
        XCTAssertEqual(dateRangeService.defaultRange.rawValue, dateRangeService.load().rangeName)

        dateRangeService.save(rangeName: DateRangeService.Range.today.rawValue)

        XCTAssertEqual(DateRangeService.Range.today.rawValue, dateRangeService.load().rangeName)

        dateRangeService.save(dateRange: DateRange(from: Date(), to: Date(), rangeName: DateRangeService.Range.others.rawValue))

        XCTAssertEqual(DateRangeService.Range.others.rawValue, dateRangeService.load().rangeName)
    }
}

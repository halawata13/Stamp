//
//  DateRangeSelectorUITests.swift
//

import XCTest

class DateRangeSelectorUITests: StampUITests {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_select_date_range_tab_historyList() {
        let app = XCUIApplication()
        app.tabBars.buttons["足跡リスト"].tap()

        select_date_range()
    }

    func test_select_date_range_tab_historyMap() {
        let app = XCUIApplication()
        app.tabBars.buttons["足跡マップ"].tap()

        select_date_range()
    }

    private func select_date_range() {
        let app = XCUIApplication()
        app.buttons["dateRangeButton"].tap()

        XCTAssertTrue(app.navigationBars["表示する期間"].exists)

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["最近1年間"]/*[[".cells.staticTexts[\"最近1年間\"]",".staticTexts[\"最近1年間\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        XCTAssertEqual("最近1年間", app.buttons["dateRangeButton"].label)
        XCTAssertEqual(0, app.textFields.count)

        app.buttons["dateRangeButton"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["期間を指定"]/*[[".cells.staticTexts[\"期間を指定\"]",".staticTexts[\"期間を指定\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        XCTAssertEqual(2, app.textFields.count)
    }
}

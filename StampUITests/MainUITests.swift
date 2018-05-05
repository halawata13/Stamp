//
//  MainUITests.swift
//

import XCTest

class MainUITests: StampUITests {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_tab_main() {
        let app = XCUIApplication()

        XCTAssertTrue(app.navigationBars["現在地の記録"].exists)

        app/*@START_MENU_TOKEN@*/.buttons["recordButton"]/*[[".buttons[\"stamp\"]",".buttons[\"recordButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["確認"].buttons["OK"].tap()
        app.textFields["タイトルを入力..."].tap()
        app.textFields["タイトルを入力..."].typeText("現在地の記録テスト")
        app.navigationBars["Stamp.SingleMapView"].buttons["現在地の記録"].tap()

        XCTAssertTrue(app.navigationBars["現在地の記録"].exists)
    }

    func test_tab_historyList() {
        let app = XCUIApplication()
        app.tabBars.buttons["足跡リスト"].tap()

        XCTAssertTrue(app.navigationBars["足跡リスト"].exists)

        let locationCount = app.tables.cells.count

        app.tabBars.buttons["現在地の記録"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["recordButton"]/*[[".buttons[\"stamp\"]",".buttons[\"recordButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["確認"].buttons["OK"].tap()
        app.tabBars.buttons["足跡リスト"].tap()

        XCTAssertEqual(locationCount + 1, app.tables.cells.count)

        let tablesQuery = app.tables
        tablesQuery.cells.firstMatch.tap()

        app.textFields["タイトルを入力..."].tap()
        app.textFields["タイトルを入力..."].typeText("足跡リストテスト")
        app.navigationBars["Stamp.SingleMapView"].buttons["足跡リスト"].tap()

        XCTAssertTrue(tablesQuery.cells.firstMatch.staticTexts["足跡リストテスト"].exists)
    }

    func test_tab_historyMap() {
        let app = XCUIApplication()
        app.tabBars.buttons["足跡マップ"].tap()

        XCTAssertTrue(app.navigationBars["足跡マップ"].exists)

        XCTAssertEqual(1, app.maps.count)
    }
}

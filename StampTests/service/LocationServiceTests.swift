//
//  LocationServiceTests.swift
//

import XCTest
import UIKit
import CoreData
import MapKit
@testable import Stamp

class LocationServiceTests: XCTestCase {

    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        deleteAllData()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInsert() {
        let returnValue = LocationService.insert(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(35), CLLocationDegrees(135)))!
        XCTAssertNotNil(returnValue)

        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let location = try! context.fetch(fetchRequest).last!

        XCTAssertEqual(returnValue.id, location.id)
        XCTAssertEqual(returnValue.date, location.date)
        XCTAssertEqual(returnValue.latitude, location.latitude)
        XCTAssertEqual(returnValue.longitude, location.longitude)
        XCTAssertEqual("", location.memo)
    }

    func testUpdate() {
        let id = insert()
        let returnValue = LocationService.update(id: id, memo: "updated")

        XCTAssertTrue(returnValue)

        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let updatedLocation = try! context.fetch(fetchRequest).last!

        XCTAssertEqual("updated", updatedLocation.memo)
    }

    func testUpdate_not_exist_id() {
        let returnValue = LocationService.update(id: UUID(), memo: "bar")

        XCTAssertFalse(returnValue)
    }

    func testDelete() {
        let id = insert()
        let returnValue = LocationService.delete(id: id)

        XCTAssertTrue(returnValue)

        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let locations = try! context.fetch(fetchRequest)

        XCTAssertEqual(0, locations.count)
    }

    func testDelete_not_exist_id() {
        let returnValue = LocationService.delete(id: UUID())

        XCTAssertFalse(returnValue)
    }

    func testFetch_by_id() {
        let id = insert()
        let fetched = LocationService.fetch(by: id)

        XCTAssertNotNil(fetched)
        XCTAssertEqual(35, fetched!.latitude)
        XCTAssertEqual(135, fetched!.longitude)
    }

    func testFetch_by_id_not_exist_id() {
        let fetched = LocationService.fetch(by: UUID())

        XCTAssertNil(fetched)
    }

    func testFetch_by_date() {
        let today = Date()
        let yesterday = Date(timeIntervalSinceNow: 60 * 60 * 24 * -1)
        let _ = insert(date: yesterday)

        XCTAssertEqual(0, LocationService.fetch(by: today)!.count)
        XCTAssertEqual(1, LocationService.fetch(by: yesterday)!.count)
    }

    func testFetch_from_to() {
        let tomorrow = Date(timeIntervalSinceNow: 60 * 60 * 24 * 1).at0!
        let today = Date().at0!
        let yesterday = Date(timeIntervalSinceNow: 60 * 60 * 24 * -1).at0!
        let _ = insert(date: tomorrow)
        let _ = insert(date: today)
        let _ = insert(date: yesterday)

        XCTAssertEqual(3, LocationService.fetch(from: yesterday, to: tomorrow)!.count)
        XCTAssertEqual(1, LocationService.fetch(from: yesterday, to: yesterday)!.count)
        XCTAssertEqual(2, LocationService.fetch(from: today, to: tomorrow)!.count)
        XCTAssertEqual(0, LocationService.fetch(from: Date(timeIntervalSinceNow: 60 * 60 * 24 * -3).at0!, to: Date(timeIntervalSinceNow: 60 * 60 * 24 * -2).at0!)!.count)
        XCTAssertEqual(0, LocationService.fetch(from: tomorrow, to: yesterday)!.count)
    }

    func testFetchAll() {
        XCTAssertEqual(0, LocationService.fetchAll().count)

        let _ = insert()
        let _ = insert()
        let _ = insert()

        XCTAssertEqual(3, LocationService.fetchAll().count)
    }

    func test_convert() {
        let plain = LocationService.convert(latitude: -12.345, longitude: 123.45, convertType: .plain)
        let detail = LocationService.convert(latitude: -12.345, longitude: 123.45, convertType: .detail)

        XCTAssertEqual("-12.345 +123.45", plain)
        XCTAssertEqual("南緯12.345 東経123.45", detail)
    }

    func test_convert_latitude() {
        let plain = LocationService.convert(latitude: -12.345, convertType: .plain)
        let detail = LocationService.convert(latitude: -12.345, convertType: .detail)

        XCTAssertEqual("-12.345", plain)
        XCTAssertEqual("南緯12.345", detail)
    }

    func test_convert_longitude() {
        let plain = LocationService.convert(longitude: 123.45, convertType: .plain)
        let detail = LocationService.convert(longitude: 123.45, convertType: .detail)

        XCTAssertEqual("+123.45", plain)
        XCTAssertEqual("東経123.45", detail)
    }

    func insert(latitude: Double = 35, longitude: Double = 135, date: Date = Date()) -> UUID {
        let location = Location(context: context)
        let id = UUID()
        location.id = id
        location.date = date as NSDate
        location.latitude = latitude
        location.longitude = longitude
        location.memo = ""

        context.insert(location)
        try! context.save()

        return id
    }

    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try! context.execute(deleteRequest)
        try! context.save()
    }
}

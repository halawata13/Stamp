//
//  LocationService.swift
//

import MapKit
import CoreData

class LocationService {
    ///
    /// 座標を追加する
    ///
    static func insert(coordinate: CLLocationCoordinate2D) -> Location? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure()
            return nil
        }

        let context = appDelegate.persistentContainer.viewContext

        let location = Location(context: context)
        location.id = UUID()
        location.date = NSDate()
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.memo = ""

        context.insert(location)

        return (try? context.save()) != nil ? location : nil
    }

    ///
    /// memo を更新する
    ///
    static func update(id: UUID, memo: String) -> Bool {
        guard let context = LocationService.getContext(),
              let location = fetch(by: id) else {
            return false
        }

        location.setValue(memo, forKey: "memo")

        return (try? context.save()) != nil
    }

    ///
    /// 座標を削除する
    ///
    static func delete(id: UUID) -> Bool {
        guard let context = LocationService.getContext(),
              let location = fetch(by: id) else {
            return false
        }

        context.delete(location)

        return (try? context.save()) != nil
    }

    ///
    /// id で座標を取得
    ///
    static func fetch(by id: UUID) -> Location? {
        guard let context = LocationService.getContext() else {
            return nil
        }

        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [id])

        do {
            return try context.fetch(fetchRequest).first

        } catch {
            return nil
        }
    }

    ///
    /// 日付で座標を取得
    ///
    static func fetch(by date: Date) -> [Location]? {
        guard let context = LocationService.getContext() else {
            return nil
        }

        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        guard let targetDay = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date))) else {
            assertionFailure()
            return nil
        }

        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF.date >= %@ AND SELF.date < %@", argumentArray: [targetDay as NSDate, NSDate(timeInterval: 24 * 60 * 60, since: date)])

        return try? context.fetch(fetchRequest)
    }

    ///
    /// 日付の期間で座標を取得
    ///
    static func fetch(from fromDate: Date, to toDate: Date) -> [Location]? {
        guard let context = LocationService.getContext() else {
            return nil
        }

        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF.date >= %@ AND SELF.date < %@", argumentArray: [fromDate as NSDate, NSDate(timeInterval: 24 * 60 * 60, since: toDate)])

        return try? context.fetch(fetchRequest)
    }

    ///
    /// 座標を全件取得
    ///
    static func fetchAll() -> [Location] {
        guard let context = LocationService.getContext() else {
            return [Location]()
        }

        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()

        return (try? context.fetch(fetchRequest)) ?? [Location]()
    }

    ///
    /// 表示用に緯度経度を加工する
    ///
    static func convert(latitude: Double, longitude: Double, convertType: ConvertType) -> String {
        let lat = LocationService.convert(latitude: latitude, convertType: convertType)
        let lng = LocationService.convert(longitude: longitude, convertType: convertType)

        return lat + " " + lng
    }

    ///
    /// 表示用に緯度を加工する
    ///
    static func convert(latitude: Double, convertType: ConvertType) -> String {
        switch convertType {
        case .plain:
            return (latitude >= 0 ? "+" : "") + String(latitude)
        case .detail:
            if latitude >= 0 {
                return "北緯" + String(latitude)
            } else {
                let lat = String(latitude)
                return "南緯" + lat.dropFirst(1)
            }
        }
    }

    ///
    /// 表示用に経度を加工する
    ///
    static func convert(longitude: Double, convertType: ConvertType) -> String {
        switch convertType {
        case .plain:
            return (longitude >= 0 ? "+" : "") + String(longitude)
        case .detail:
            if longitude >= 0 {
                return "東経" + String(longitude)
            } else {
                let lng = String(longitude)
                return "西経" + lng.dropFirst(1)
            }
        }
    }

    ///
    /// 表示用に日時を加工する
    ///
    static func convert(date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle

        return formatter.string(from: date)
    }

    private static func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure()
            return nil
        }

        return appDelegate.persistentContainer.viewContext
    }

    enum ConvertType {
        case plain
        case detail
    }
}

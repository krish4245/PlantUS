//
//  WateringHistoryStore.swift
//  PlantApp
//
//  Created by SDC-USER on 23/01/26.
//


import Foundation

final class WateringHistoryStore {

    static let shared = WateringHistoryStore()
    private let key = "wateringDates"

    private init() {}

    func markTodayDone() {
        var dates = fetchDates()
        let today = Calendar.current.startOfDay(for: Date())

        if !dates.contains(today) {
            dates.append(today)
            save(dates)
        }
    }

    func fetchDates() -> [Date] {
        guard let timestamps = UserDefaults.standard.array(forKey: key) as? [TimeInterval] else {
            return []
        }
        return timestamps.map { Date(timeIntervalSince1970: $0) }
    }

    private func save(_ dates: [Date]) {
        let timestamps = dates.map { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(timestamps, forKey: key)
    }
}

////
////  PlantModel 2.swift
////  PlantApp
////
////  Created by SDC-USER on 11/12/25.
////
//
//
//import Foundation
//
//// Simple plant model
//struct PlantModel: Codable {
//    let name: String
//    let description: String?    // longer description
//    let benefit: String?        // one-line benefit
//    let watering: String?
//    let sunlight: String?
//    let soil: String?
//    let imageURL: String?
//}
//
//// Singleton DB to load plants.json and find best match
//class PlantDatabase {
//    static let shared = PlantDatabase()
//
//    private(set) var plants: [PlantModel] = []
//
//    private init() {
//        loadBundleJSON()
//    }
//
//    private func loadBundleJSON() {
//        guard let url = Bundle.main.url(forResource: "plants", withExtension: "json") else {
//            print("plants.json not found in bundle")
//            return
//        }
//        do {
//            let data = try Data(contentsOf: url)
//            let dec = JSONDecoder()
//            self.plants = try dec.decode([PlantModel].self, from: data)
//        } catch {
//            print("Failed to load plants.json:", error)
//        }
//    }
//
//    // Find best match: exact, substring, then small levenshtein
//    func bestMatch(for query: String) -> PlantModel? {
//        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        if q.isEmpty { return nil }
//
//        if let exact = plants.first(where: { $0.name.lowercased() == q }) { return exact }
//        if let substring = plants.first(where: { $0.name.lowercased().contains(q) }) { return substring }
//
//        var best: (PlantModel, Int)? = nil
//        for p in plants {
//            let d = Self.levenshtein(aStr: p.name.lowercased(), bStr: q)
//            if best == nil || d < best!.1 {
//                best = (p, d)
//            }
//        }
//        if let b = best, b.1 <= 3 { return b.0 } // threshold of 3 edits
//        return nil
//    }
//
//    // fallback: when not found at all, return a lightweight default stub
//    func fallbackModel(named name: String) -> PlantModel {
//        return PlantModel(
//            name: name,
//            description: "No detailed data available for \(name). You can add it to the database or try another scan.",
//            benefit: "General benefit: adds greenery and improves air quality.",
//            watering: nil,
//            sunlight: nil,
//            soil: nil,
//            imageURL: nil
//        )
//    }
//
//    // Levenshtein (same as earlier)
//    private static func levenshtein(aStr: String, bStr: String) -> Int {
//        let a = Array(aStr), b = Array(bStr)
//        let n = a.count, m = b.count
//        if n == 0 { return m }
//        if m == 0 { return n }
//        var d = Array(repeating: Array(repeating: 0, count: m+1), count: n+1)
//        for i in 0...n { d[i][0] = i }
//        for j in 0...m { d[0][j] = j }
//        for i in 1...n {
//            for j in 1...m {
//                let cost = a[i-1] == b[j-1] ? 0 : 1
//                d[i][j] = min(d[i-1][j] + 1, d[i][j-1] + 1, d[i-1][j-1] + cost)
//            }
//        }
//        return d[n][m]
//    }
//}
//

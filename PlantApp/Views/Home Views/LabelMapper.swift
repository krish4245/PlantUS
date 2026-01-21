//
//  LabelMapper.swift
//  PlantApp
//
//  Created by SDC-USER on 10/12/25.
//


// LabelMapper.swift
import Foundation


struct LabelMapper {
   
    static var labelToAppName: [String: String] = [
        "monstera deliciosa": "Monstera",
        "monstera": "Monstera",
        "chlorophytum comosum": "Spider Plant",
        "spider plant": "Spider Plant",
        "epipremnum aureum": "Money Plant",
        "pothos": "Money Plant",
        "ficus elastica": "Ficus Elastic", // change to the exact PlantData name if different
        "ficus": "Ficus Elastic",
        "spathiphyllum wallisii": "Peace Lily",
        "sansevieria trifasciata": "Snake Plant",
        "zamioculcas zamiifolia": "ZZ Plant",
        "aloe vera": "Aloe",
        "aglaonema": "Aglaonema",
        "philodendron": "Philodendron",
        "pilea peperomioides": "Pilea",
        "dracaena marginata": "Dracaena"
        // add or adjust entries to match your PlantData names exactly
    ]

  
    static func appName(from rawLabel: String?) -> String? {
        guard let raw = rawLabel?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !raw.isEmpty else { return nil }
        // direct lookup
        if let v = labelToAppName[raw] { return v }
        // try partial match: check if any key is a substring of raw (useful if model label includes extras)
        for (k, v) in labelToAppName {
            if raw.contains(k) { return v }
        }
        // last fallback: return raw with capitalization (you can decide)
        return raw.split(separator: " ").map { $0.capitalized }.joined(separator: " ")
    }
}

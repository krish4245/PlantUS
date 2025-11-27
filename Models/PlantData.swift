import Foundation

struct Plant {
    let name: String
    let tagline: String        // Used for Recommended (e.g. "Beginner Friendly")
    let maintenance: String    // Used for Browse (e.g. "Easy Maintenance")
    let light: String          // e.g. "Bright Indirect"
    let water: String          // e.g. "Weekly"
    let imageName: String
}

class PlantData {
    // SECTION 0: Recommended Plants
    static let recommended: [Plant] = [
        Plant(name: "Monstera", tagline: "Beginner Friendly", maintenance: "Easy", light: "Bright", water: "Weekly", imageName: "monstera"),
        Plant(name: "Spider Plant", tagline: "Water Today", maintenance: "Easy", light: "Bright", water: "Weekly", imageName: "spider"),
        Plant(name: "Sunny Stem", tagline: "Moderate Main...", maintenance: "Moderate", light: "Sun", water: "Daily", imageName: "sunny")
    ]
    
    // SECTION 2: Browse Plants
    static let browse: [Plant] = [
        Plant(name: "Spider Plant", tagline: "", maintenance: "Easy Maintenance", light: "Bright Indirect", water: "Weekly", imageName: "spider"),
        Plant(name: "Lil Sprout", tagline: "", maintenance: "Beginner Friendly", light: "Bright Indirect", water: "Keep Moist", imageName: "sprout"),
        Plant(name: "Sunny Stem", tagline: "", maintenance: "Moderate Maintenance", light: "Bright Indirect", water: "Keep Moist", imageName: "sunny"),
        Plant(name: "Coco Fern", tagline: "", maintenance: "High Maintenance", light: "Bright Indirect", water: "Keep Moist", imageName: "fern"),
        Plant(name: "Mossy Moo", tagline: "", maintenance: "Expert Care", light: "Bright Indirect", water: "Keep Moist", imageName: "mossy")
    ]
}

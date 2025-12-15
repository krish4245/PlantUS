import Foundation

struct BrowsePlant {
    let name: String
    let tagline: String        // Used for Recommended (e.g. "Beginner Friendly")
    let maintenance: String    // Used for Browse (e.g. "Easy Maintenance")
    let light: String          // e.g. "Bright Indirect"
    let water: String          // e.g. "Weekly"
    let imageName: String
}

class PlantData {
    // SECTION 0: Recommended Plants
    static let recommended: [BrowsePlant] = [
        BrowsePlant(name: "Monstera", tagline: "Beginner Friendly", maintenance: "Easy", light: "Bright", water: "Weekly", imageName: "monstera"),
        BrowsePlant(name: "Spider Plant", tagline: "Water Today", maintenance: "Easy", light: "Bright", water: "Weekly", imageName: "spider"),
        BrowsePlant(name: "Sunny Stem", tagline: "Moderate Main...", maintenance: "Moderate", light: "Sun", water: "Daily", imageName: "sunny")
    ]
    
    // SECTION 2: Browse Plants
    static let browse: [BrowsePlant] = [
        BrowsePlant(name: "Spider Plant", tagline: "", maintenance: "Easy Maintenance", light: "Bright Indirect", water: "Weekly", imageName: "spider"),
        BrowsePlant(name: "Lil Sprout", tagline: "", maintenance: "Beginner Friendly", light: "Bright Indirect", water: "Keep Moist", imageName: "sprout"),
        BrowsePlant(name: "Sunny Stem", tagline: "", maintenance: "Moderate Maintenance", light: "Bright Indirect", water: "Keep Moist", imageName: "sunny"),
        BrowsePlant(name: "Coco Fern", tagline: "", maintenance: "High Maintenance", light: "Bright Indirect", water: "Keep Moist", imageName: "fern"),
        BrowsePlant(name: "Mossy Moo", tagline: "", maintenance: "Expert Care", light: "Bright Indirect", water: "Keep Moist", imageName: "mossy")
    ]
}

import Foundation

final class PlantDataSource {

    static let shared = PlantDataSource()

    let recommendedPlants: [PlantModel_Ved]
    let allPlants: [PlantModel_Ved]

    private(set) var plants: [PlantModel_Ved]

    private init() {
        
        
        let allPlantsData: [PlantModel_Ved] = [
            
            PlantModel_Ved(
                id: "snake_plant",
                name: "Snake Plant",
                tagline: "Beginner Friendly",
                description: "A hardy indoor plant known for air purification and low maintenance.",
                careDifficulty: .easy,
                light: "Low to bright indirect light",
                water: "Once every 10–14 days",
                soil: "Well-draining soil",
                imageName: "snake_plant",
                careTasks: [CareType.watering, CareType.fertilizing]

                
                
            ),
            
            PlantModel_Ved(
                id: "money_plant",
                name: "Money Plant",
                tagline: "Low Maintenance",
                description: "Popular indoor vine believed to bring prosperity and positivity.",
                careDifficulty: .easy,
                light: "Bright indirect light",
                water: "Weekly",
                soil: "Loose potting mix",
                imageName: "money_plant",
                careTasks: [CareType.watering, CareType.fertilizing]
                
            ),
            
            PlantModel_Ved(
                id: "peace_lily",
                name: "Peace Lily",
                tagline: "Air Purifier",
                description: "Elegant flowering plant that thrives indoors with moderate care.",
                careDifficulty: .moderate,
                light: "Low to medium indirect light",
                water: "When soil is dry",
                soil: "Moist but well-drained",
                imageName: "spider_plant",
                careTasks: [CareType.watering, CareType.fertilizing]
                
            ),
            
            PlantModel_Ved(
                id: "aloe_vera",
                name: "Aloe Vera",
                tagline: "Medicinal Plant",
                description: "Succulent plant known for its healing gel and drought tolerance.",
                careDifficulty: .easy,
                light: "Bright sunlight",
                water: "Every 2–3 weeks",
                soil: "Cactus soil",
                imageName: "sunny",
                careTasks: [CareType.watering, CareType.fertilizing]
                
            )
        ]
        
        
        self.plants = allPlantsData
        self.allPlants = allPlantsData
        
        self.recommendedPlants = allPlantsData.filter {
            $0.careDifficulty == .easy
        }
        
    }
        
     
    
}

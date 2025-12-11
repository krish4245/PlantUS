//
//  DataStore.swift
//  PlantApp
//
//  Created by SDC-USER on 26/11/25.
//

import Foundation
class DataStore {
    var ques1button = [ques1_button(image: "bed.double.fill", site: "Bedroom"), ques1_button(image: "sofa.fill", site: "Living Room"), ques1_button(image: "shower.fill", site: "Bathroom"), ques1_button(image: "fireplace.fill", site: "Hall")]
    func getQues1button() -> [ques1_button] {
        return ques1button
    }
    
    var plantLightOptions: [PlantLightOption] = [
        PlantLightOption(image: "moon.fill", light: "Low Light"),
        PlantLightOption(image: "sun.max.fill", light: "Full Sun"),
        PlantLightOption(image: "sun.haze.fill", light: "Partial Sun")
    ]
    func getPlantLightOptions() -> [PlantLightOption] {
        return plantLightOptions
    }
    
    
}

var dataStore = DataStore()

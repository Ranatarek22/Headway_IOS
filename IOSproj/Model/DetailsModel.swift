//
//  DetailsModel.swift
//  IOSproj
//
//  Created by Rana Tarek on 29/01/2025.
//

import Foundation


//struct BadgeModel: Identifiable {
//    let id: Int
//    let name: String
//    let image: String
//}

struct ModelData {
    var hikes: [Hike] = [
        Hike(
            name: "Lonesome Ridge Trail",
            distance: "5.0 km",
            observations: [
                Hike.Observation(elevation: 100, heartRate: 120, pace: 5.0, temperature: 70, humidity: 40),
                Hike.Observation(elevation: 150, heartRate: 130, pace: 5.5, temperature: 72, humidity: 45),
                Hike.Observation(elevation: 200, heartRate: 140, pace: 6.0, temperature: 75, humidity: 50),
                Hike.Observation(elevation: 250, heartRate: 150, pace: 6.5, temperature: 78, humidity: 55),
                Hike.Observation(elevation: 300, heartRate: 160, pace: 7.0, temperature: 80, humidity: 60)
            ]
        )
    ]
}
struct Hike: Identifiable {
    let id = UUID()
    var name: String
    var distance: String
    var observations: [Observation]

    struct Observation {
        var elevation: Double
        var heartRate: Double
        var pace: Double
        var temperature: Double
        var humidity: Double
    }
}

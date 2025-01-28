//
//  J.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/25/25.
//

import Foundation

struct Location: Identifiable, Codable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    var temperature: Double?
    var icon: String?
}

struct WeatherInfo {
    let humidity: Int
    let uvIndex: Int
    let feelsLike: Int
}

struct CurrentWeatherResponse: Codable {
    struct Current: Codable {
        let temp_c: Double
        let feelslike_c: Double
        let humidity: Int
        let uv: Double
        let condition: Condition
    }

    struct Condition: Codable {
        let icon: String
    }

    let current: Current
}

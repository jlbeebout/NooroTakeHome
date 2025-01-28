//
//  SelectedLocationViewModel.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//

import SwiftUI

class SelectedLocationViewModel: ObservableObject {
    @Published var temperature: Double? = nil
    @Published var iconURL: String? = nil
    @Published var weatherInfo: WeatherInfo? = nil

    private let apiKey = Constants.apiKey

    func fetchWeather(for location: Location) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(location.lat),\(location.lon)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned from weather API.")
                return
            }

            do {
                let response = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.temperature = response.current.temp_c
                    self.iconURL = "https:\(response.current.condition.icon)".replacingOccurrences(of: "64x64", with: "128x128")
                    self.weatherInfo = WeatherInfo(
                        humidity: response.current.humidity,
                        uvIndex: Int(response.current.uv),
                        feelsLike: Int(response.current.feelslike_c)
                    )
                }
            } catch {
                print("Decoding error: \(error)")
                print("Raw response: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
    }
}

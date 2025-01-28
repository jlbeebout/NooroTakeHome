//
//  WeatherInfoView.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//

import SwiftUI

struct WeatherInfoView: View {
    let humidity: Int
    let uvIndex: Int
    let feelsLike: Int

    var body: some View {
        HStack(spacing: 0) {
            // Humidity
            VStack(spacing: 4) {
                Text("Humidity")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(humidity)%")
                    .poppins(.medium, size: 15)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)

            // UV Index
            VStack(spacing: 4) {
                Text("UV")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(uvIndex)")
                    .poppins(.medium, size: 15)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)

            // Feels Like Temperature
            VStack(spacing: 4) {
                Text("Feels Like")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(feelsLike)°")
                    .poppins(.medium, size: 15)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 274, height: 75)
        .background(Color.lightBackground)
        .cornerRadius(16)
    }
}

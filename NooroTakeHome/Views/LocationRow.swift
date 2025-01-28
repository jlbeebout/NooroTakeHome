//
//  LocationRow.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//

import SwiftUI

struct LocationRow: View {
    let location: Location
    @Binding var searchText: String
    let onSelect: (Location) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(location.name)
                    .poppins(.semiBold, size: 22)
                    .foregroundColor(.black)

                if let temperature = location.temperature {
                    ZStack(alignment: .topTrailing) {
                        Text("\(Int(temperature))")
                            .poppins(.medium, size: 55)
                            .foregroundColor(.black)
                        Text("°")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .offset(x: 12, y: 2) 
                    }
                } else {
                    Text("Loading...")
                        .poppins(.regular, size: 16)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 15)

            Spacer()
            
            if let iconURL = location.icon, let url = URL(string: iconURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color(.lightGray)
                }
                .frame(width: 90, height: 90)
            } else {
                ProgressView()
                    .frame(width: 60, height: 60)
            }
        }
        .padding(16)
        .frame(height: 117)
        .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
        .cornerRadius(12)
        .padding(.vertical, 8)
        .onTapGesture {
            searchText = ""
            onSelect(location)
        }
    }
}

//
//  SearchBar.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        VStack {
            HStack {
                TextField("Search Location", text: $text)
                    .poppins(.regular, size: 15)
                    .padding(.vertical, (46 - 22.5) / 2)
                    .padding(.leading, 12)
                    .lineSpacing(22.5 - 15)

                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 17.5, height: 17.5)
                    .foregroundColor(.gray)
                    .padding(.trailing, 12)
            }
            .frame(height: 46)
            .background(Color.lightBackground)
            .cornerRadius(16)
            .padding(.horizontal, 25)
        }
        .padding(.top, 44)
    }
}

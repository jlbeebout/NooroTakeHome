//
//  BodyView.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//
import SwiftUI

struct BodyView: View {
    @StateObject private var viewModel = LocationSearchViewModel()

    var body: some View {
        ZStack {
            if viewModel.searchText.isEmpty && viewModel.locations.isEmpty {
                if let selectedLocation = viewModel.selectedLocation {
                    SelectedLocationView(location: selectedLocation)
                } else {
                    EmptySearchMessageView()
                }
            }

            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }

                if !viewModel.locations.isEmpty {
                    ScrollView {
                        ForEach(viewModel.locations) { location in
                            LocationRow(location: location, searchText: $viewModel.searchText) { selectedLocation in
                                viewModel.saveLocationToUserDefaults(selectedLocation)
                                viewModel.searchText = "" // Clear the searchText
                                print("Selected location: \(selectedLocation.name)")
                            }
                        }
                        .padding(.horizontal, 20)
                    }.padding(.top, 25)
                } else if !viewModel.searchText.isEmpty && !viewModel.isLoading {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

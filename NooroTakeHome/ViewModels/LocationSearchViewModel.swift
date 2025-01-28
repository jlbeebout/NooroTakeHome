//
//  LocationSearchViewModel.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//
import Foundation
import Combine

class LocationSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var locations: [Location] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedLocation: Location? = nil

    private let locationService = LocationService()
    private var cancellables = Set<AnyCancellable>()
    private let apiKey = Constants.apiKey

    init() {
        observeSearchText()
        loadSelectedLocation()
    }

    private func observeSearchText() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchLocations(query: query)
            }
            .store(in: &cancellables)
    }

    private func searchLocations(query: String) {
        guard !query.isEmpty else {
            self.locations = []
            return
        }

        isLoading = true
        errorMessage = nil

        locationService.fetchLocations(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let locations):
                    self?.fetchTemperatures(for: locations)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func fetchTemperatures(for locations: [Location]) {
        let group = DispatchGroup()
        var updatedLocations = locations

        for (index, location) in locations.enumerated() {
            group.enter()
            fetchTemperature(for: location) { temperature, icon in
                if let temperature = temperature {
                    updatedLocations[index].temperature = temperature
                }
                if let icon = icon?.replacingOccurrences(of: "64x64", with: "128x128") {
                    updatedLocations[index].icon = icon
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.locations = updatedLocations
        }
    }

    private func fetchTemperature(for location: Location, completion: @escaping (Double?, String?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(location.lat),\(location.lon)"
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil, nil)
                return
            }

            if let response = try? JSONDecoder().decode(CurrentWeatherResponse.self, from: data) {
                completion(response.current.temp_c, "https:\(response.current.condition.icon)")
            } else {
                completion(nil, nil)
            }
        }.resume()
    }

    func saveLocationToUserDefaults(_ location: Location) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(location) {
            UserDefaults.standard.set(encoded, forKey: "selectedLocation")
            selectedLocation = location
        }
    }

    func loadSelectedLocation() {
        if let savedData = UserDefaults.standard.data(forKey: "selectedLocation") {
            let decoder = JSONDecoder()
            if let savedLocation = try? decoder.decode(Location.self, from: savedData) {
                selectedLocation = savedLocation
            }
        }
    }
}

class LocationService {
    private let apiKey = Constants.apiKey
    
    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        guard !query.isEmpty else {
            completion(.success([]))
            return
        }
        
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(queryEncoded)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let locations = try JSONDecoder().decode([Location].self, from: data)
                completion(.success(locations))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

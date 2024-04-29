//
//  CityView.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import SwiftUI
import Alamofire

struct CityView: View {
    @State var cities: [String] = []
    @State var selected:Int?
    let country: String
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            if cities.isEmpty {
                ProgressViewWithAlert(showingAlert: $showingAlert, alertMessage: alertMessage)
            } else {
                List(cities, id: \.self, selection: $selected) { city in
                    NavigationLink {
                        DistrictView(country: country, city: city)
                    } label: {
                        Text(city)
                    }
                }
            }
        }.onAppear {
            Task {
                do {
                    let response = try await URLSession.shared.data(from: ServiceApi.cityOrRegion(country: country).url())
                    cities = try JSONDecoder().decode([String].self, from: response.0)
                }
                catch {
                    print(error)
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
}

#Preview {
    CityView(country: "Turkey")
}

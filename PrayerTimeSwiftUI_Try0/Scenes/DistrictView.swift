//
//  DistrictView.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import SwiftUI

struct DistrictView: View {
    @State var districts: [String] = []
    @State var selected:Int?
    let country: String
    let city: String
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            if districts.isEmpty {
                ProgressViewWithAlert(showingAlert: $showingAlert, alertMessage: alertMessage)
            } else {
                List(districts, id: \.self, selection: $selected) { district in
                    NavigationLink {
                        MainView(model: TimesResponse(place: Place(country: country, city: district, region: city, latitude: nil, longitude: nil)), locationType: PlaceType.map(locPermissionAllowed: false))
                    } label: {
                        Text(district)
                    }
                }
            }
        }.onAppear {
            Task {
                do {
                    let response = try await URLSession.shared.data(from: ServiceApi.district(country: country, city: city).url())
                    districts = try JSONDecoder().decode([String].self, from: response.0)
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
    DistrictView(country: "Turkey", city: "Ankara")
}

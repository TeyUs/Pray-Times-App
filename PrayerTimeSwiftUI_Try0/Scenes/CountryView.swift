//
//  ContentView.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 10.04.2024.
//

import SwiftUI
import Alamofire

struct CountryView: View {
    @State var countries: [Country] = []
    @State var selected:Int?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            if countries.isEmpty {
                ProgressViewWithAlert(showingAlert: $showingAlert, alertMessage: alertMessage)
            } else {
                NavigationLink {
                    CityView(country: "Turkey")
                } label: {
                    Text("Turkey")
                        .font(Font.system(size: 16))
                        .foregroundStyle(.black)
                }
                List(countries, id: \.self, selection: $selected) { country in
                    NavigationLink {
                        CityView(country: country.name ?? "Turkey")
                    } label: {
                        Text(country.name ?? "")
                    }
                }
            }
        }.onAppear {
            Task {
                do {
                    let response = try await URLSession.shared.data(from: ServiceApi.country.url())
                    countries = try JSONDecoder().decode(Countries.self, from: response.0)
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
    CountryView()
}

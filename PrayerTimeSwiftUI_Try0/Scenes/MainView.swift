//
//  MainView.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 15.04.2024.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @EnvironmentObject var env: EnvirnmentVariables
    @StateObject var locationDataManager = LocationManager()
    
    @State var model: TimesResponse?
    @State var prayTimes: [String]?
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State var locationType: PlaceType = .location
    @State var goToMaps: Bool = false
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    //STOP
    var body: some View {
        NavigationStack {
            if model == nil || showingAlert == true {
                ProgressViewWithAlert(showingAlert: $showingAlert, alertMessage: alertMessage)
            } else {
                VStack {
                    Button {
                        refresh()
                    } label: {
                        Image(systemName: locationType.refreshButton)
                        Text("\(model?.place?.country ?? "") \(model?.place?.region ?? "") \(model?.place?.city ?? "")")
                        Image(systemName: "arrow.clockwise.circle")
                    }
                    VStack {
                        DigitalClock(prayTimes: $prayTimes)
                        TimesView(prayTimes: $prayTimes)
                    }
                    .padding(10)
                }
                .padding(10)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            toolBarButtonTapped()
                        } label: {
                            Image(systemName: locationType.navbarButtonImage)
                        }
                        
                    }
                }.navigationDestination(isPresented: $goToMaps) {
                    CountryView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            onAppear()
        }.onDisappear {
            storeData()
        }
    }

//    MARK: Logic
    func onAppear() {
        if model?.place?.country == nil {
            getDataFromStorage()
        }
        if locationType != .location  { //any map
            fetchTimesWithNames()
            locationType = .map(locPermissionAllowed: isPermissionAllowed())
        } else {
            if isPermissionAllowed() {
                locationType = .location
                getCoordinatesAndFetch()
            }
        }
    }
    
    func toolBarButtonTapped() {
        if locationType == .location {
            locationType = .map(locPermissionAllowed: true)
            goToMaps = true
        } else { //map
            if isPermissionAllowed() {
                locationType = .location
                getCoordinatesAndFetch()
            } else {
                locationType = .map(locPermissionAllowed: false)
                showingAlert = true
                alertMessage = "Permission Denied!\nPlease go to Settings and turn on the permissions."
            }
        }
    }
    
    func refresh() {
        if locationType == .location {
            getCoordinatesAndFetch()
        } else {
            goToMaps = true
        }
    }
    
    func isPermissionAllowed() -> Bool{
        switch locationDataManager.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
//    MARK: Storage
    func getDataFromStorage() {
        let storageManager = StorageManager.shared
        
        if let isLocationType = storageManager.isLocationType {
            locationType = isLocationType ? .location : .map(locPermissionAllowed: isPermissionAllowed())
        }
        
        guard let storedModel = storageManager.lastData,
              let times = storedModel.times?.values.first else { return }
        print(storedModel)
        self.model = storedModel
        self.prayTimes = times
        env.updateActiveTime(prayTimes)
    }
    
    func storeData() {
        print(model as Any)
        let storageManager = StorageManager.shared
        storageManager.lastData = model
        storageManager.activeTime = env.activeTime
        storageManager.isLocationType = locationType == .location
        storageManager.storeData()
    }
    
//    MARK: Service
    func getCoordinatesAndFetch() {
        let coordinate = CLLocationManager().location?.coordinate
        guard let latitude = coordinate?.latitude,
              let longitude = coordinate?.longitude else { return }
        
        model?.place?.latitude = latitude
        model?.place?.longitude = longitude
        print(latitude)
        print(longitude)
        fetchTimesWithLocation(latitude: latitude, longitude: longitude)
    }
    
    func fetchTimesWithLocation(latitude: Double, longitude: Double) {
        Task {
            do {
                let response = try await URLSession.shared.data(from: ServiceApi.timesWithLocation(latitude: latitude, longitude: longitude).url())
                let placeModel = try JSONDecoder().decode(Place.self, from: response.0)
                model?.place = placeModel
                fetchTimesWithNames()
            }
            catch {
                print(error)
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
    
    func fetchTimesWithNames() {
        Task {
            do {
                guard let country = model?.place?.country,
                      let city = model?.place?.city,
                      let district = model?.place?.region else { return }
                let response = try await URLSession.shared.data(from: ServiceApi.times(country: country, city: city, district: district, date: time).url())
                print(try ServiceApi.times(country: country, city: city, district: district, date: time).url())
                model = try JSONDecoder().decode(TimesResponse.self, from: response.0)
                prayTimes = model?.times?[time]
                env.updateActiveTime(prayTimes)
                storeData()
            }
            catch {
                print(error)
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
}

#Preview {
    MainView(model: TimesResponse(place: Place(country: "Turkey", city: "Ankara", region: "Beypazarı", latitude: nil, longitude: nil)))
        .environmentObject(EnvirnmentVariables())
}

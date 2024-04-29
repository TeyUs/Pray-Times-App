//
//  StorageManager.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 16.04.2024.
//

import CoreLocation
import SwiftUI

class StorageManager: ObservableObject {
    
    static let shared = StorageManager()

    @AppStorage("activeTime") var activeTime: TimesEnum?
    @AppStorage("locationType") var isLocationType: Bool?
    @AppStorage("lastLocation") private var lastLocationStore: Data?
    @AppStorage("lastData") private var lastDataStore: Data?
    
    var lastLocation: CLLocationCoordinate2D?
    var lastData: TimesResponse?
    
    init() {
        prepareData()
    }
    
    func prepareData() {
        if let lastLocationStore {
            lastLocation =  try? JSONDecoder().decode(CLLocationCoordinate2D.self, from: lastLocationStore)
        }
        if let lastDataStore {
            lastData =  try? JSONDecoder().decode(TimesResponse.self, from: lastDataStore)
        }
    }
    
    func storeData() {
        lastLocationStore = try? JSONEncoder().encode(lastLocation)
        lastDataStore = try? JSONEncoder().encode(lastData)
    }
    
    deinit {
        storeData()
    }
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        self.latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)!
        self.longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)!
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

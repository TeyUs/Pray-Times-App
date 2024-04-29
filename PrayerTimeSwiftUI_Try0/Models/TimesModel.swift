//
//  TimesModel.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import Foundation

// MARK: - Times
struct TimesResponse: Codable {
    var place: Place?
    var times: [String: [String]]?
}

// MARK: - Place
struct Place: Codable {
    var country, city, region: String?
    var latitude, longitude: Double?
}

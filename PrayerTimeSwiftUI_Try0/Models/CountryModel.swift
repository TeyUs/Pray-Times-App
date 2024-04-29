//
//  CountryModel.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 10.04.2024.
//

import Foundation

// MARK: - Country
struct Country: Codable, Hashable, Identifiable {
    var id = UUID()
    let code: String?
    let name: String?
    
    enum CodingKeys: CodingKey {
        case code
        case name
    }
}

typealias Countries = [Country]

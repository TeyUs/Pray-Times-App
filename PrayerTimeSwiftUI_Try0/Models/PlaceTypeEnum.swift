//
//  PlaceTypeEnum.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 29.04.2024.
//

import Foundation

enum PlaceType: Equatable {
    case map(locPermissionAllowed: Bool = false)
    case location
    
    var navbarButtonImage: String {
        switch self {
        case .map(let permission):
            if permission {
                return "mappin.and.ellipse"
            } else {
                return "mappin.slash.circle"
            }
        case .location:
            return "map.circle"
        }
    }
    var refreshButton: String {
        switch self {
        case .map:
            return "map.circle"
        case .location:
            return "mappin.and.ellipse"
        }
    }
}

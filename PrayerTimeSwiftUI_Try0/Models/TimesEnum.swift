//
//  TimesEnum.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import Foundation

enum TimesEnum: Int, Codable {
    case imsak
    case gunes
    case ogle
    case ikindi
    case aksam
    case yatsi
    
    var screenName: String {
        switch self {
        case .imsak:
            "İmsak"
        case .gunes:
            "Güneş"
        case .ogle:
            "Öğle"
        case .ikindi:
            "İkindi"
        case .aksam:
            "Akşam"
        case .yatsi:
            "Yatsı"
        }
    }
    
    var coloredImage: String {
        switch self {
        case .imsak:
            return "imsak_rk"
        case .gunes:
            return "gunes_rk"
        case .ogle:
            return "oglen_rk"
        case .ikindi:
            return "ikindi_rk"
        case .aksam:
            return "aksam_rk"
        case .yatsi:
            return "yatsi_rk"
        }
    }
    
    var darkImage: String {
        switch self {
        case .imsak:
            return "imsak_sb"
        case .gunes:
            return "gunes_sb"
        case .ogle:
            return "oglen_sb"
        case .ikindi:
            return "ikindi_sb"
        case .aksam:
            return "aksam_sb"
        case .yatsi:
            return "yatsi_sb"
        }
    }
    
    func updateActiveTime() {
        
    }
}

//
//  PrayerTimeSwiftUI_Try0App.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 10.04.2024.
//

import SwiftUI
import CoreLocation

@main
struct PrayerTimeSwiftUI_Try0App: App {
    var env = EnvirnmentVariables()
    var body: some Scene {
        WindowGroup {
            if StorageManager.shared.isLocationType == nil {
                CountryView()
                    .environmentObject(env)
            } else {
                MainView()
                    .environmentObject(env)
            }
        }
    }
}


class EnvirnmentVariables: ObservableObject {
    @Published var activeTime: TimesEnum?
    @Published var lastData: TimesResponse?
    
    func updateActiveTime(_ prayTimes: [String]?) {
        guard let prayTimes = prayTimes else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let curTime = dateFormatter.string(from: Date() + addTime)
        print(curTime)
        
        
        if let _activeTime = activeTime {
            if prayTimes[_activeTime.rawValue] >= curTime {
                return
            }
        }
        
        activeTime = .yatsi
        for (i, t) in prayTimes.enumerated() {
            if t >= curTime {
                activeTime = TimesEnum(rawValue: i - 1)
                break
            }
        }
    }
}


let addTime: Double = 3600 * 2 + 60 * 47

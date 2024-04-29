//
//  TimesView.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import SwiftUI

struct TimesView: View {
    @Binding var prayTimes: [String]?
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        if prayTimes != nil {
            VStack{
                HStack {
                    timeBox(for: .imsak)
                    timeBox(for: .gunes)
                }
                HStack {
                    timeBox(for: .ogle)
                    timeBox(for: .ikindi)
                }
                HStack {
                    timeBox(for: .aksam)
                    timeBox(for: .yatsi)
                }
            }
            .padding(20)
        } else {
            ProgressViewWithAlert(showingAlert: $showingAlert, alertMessage: alertMessage)
        }
    }
    
    func timeBox(for time: TimesEnum) -> TimeBox {
        return TimeBox(time: time, clock: prayTimes![time.rawValue])
    }
}

#Preview {
    TimesView(prayTimes: .constant(["08:46", "05:46", "05:46","05:46","05:46","05:46"]))
}

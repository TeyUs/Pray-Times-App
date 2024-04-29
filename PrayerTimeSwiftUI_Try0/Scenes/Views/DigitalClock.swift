//
//  DigitalClock.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 15.04.2024.
//

import SwiftUI

struct DigitalClock: View {
    @Binding var prayTimes: [String]?
    @EnvironmentObject var env: EnvirnmentVariables
    @State var timeRemain = ""
    @State var dayNow = ""
    
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("Vaktin çıkmasına")
                .font(.system(size: 10))
            Text(timeRemain)
                .font(.system(size: 45))
            Text(dayNow)
                .font(.system(size: 20))
        }
        .onAppear(){
            refreshClockData()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                refreshClockData()
            })
        }
        .onDisappear(perform: {
            timer?.invalidate()
        })
    }
    
    func refreshClockData(){
        env.updateActiveTime(prayTimes)
        guard let activeTime = env.activeTime else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let curTime = dateFormatter.string(from: Date() + addTime).split(separator: ":").map { s in return Int(s) ?? 0 }
        print(curTime)
        let nextPray = (TimesEnum(rawValue: activeTime.rawValue + 1) ?? .imsak)
        var nextPrayTime = (prayTimes?[nextPray.rawValue] ?? "00:00").split(separator: ":").map { s in return Int(s) ?? 0 }
        
        var diffMinute = nextPrayTime[1] - curTime[1]
        if diffMinute < 0 {
            diffMinute += 60
            nextPrayTime[0] -= 1
        }
        
        var diffHour = nextPrayTime[0] - curTime[0]
        if diffHour < 0 {
            diffHour += 24
        }
        timeRemain = "\(diffHour / 10)\(diffHour % 10):\(diffMinute / 10)\(diffMinute % 10)"
        
        let dateFormatterForDay = DateFormatter()
        dateFormatterForDay.dateFormat = "dd MMMM yyyy"
        self.dayNow = dateFormatterForDay.string(from: Date() + addTime)
    }
}

#Preview {
    DigitalClock(prayTimes: .constant(["08:46", "05:46", "05:46","05:46","05:46","05:46"]))
}

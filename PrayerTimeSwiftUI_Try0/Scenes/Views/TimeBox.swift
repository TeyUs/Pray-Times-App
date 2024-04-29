//
//  TimeBox.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import SwiftUI

struct TimeBox: View {
    @EnvironmentObject var env: EnvirnmentVariables
    var time: TimesEnum = .imsak
    var clock: String = "24:63"
    
    var body: some View {
        ZStack {
            Image(getImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                Text(time.screenName)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                Text(clock)
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color(white: 0, opacity: 0.5), radius: 10)
    }
    
    var getImageName: String {
        
        if time == env.activeTime {
            return time.coloredImage
        } else {
            return time.darkImage
        }
    }
}

#Preview {
    TimeBox()
}

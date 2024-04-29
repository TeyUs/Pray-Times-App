//
//  ProgressViewWithAlert.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import SwiftUI

struct ProgressViewWithAlert: View {
    @Binding var showingAlert: Bool
    var alertMessage: String
    
    var body: some View {
        ProgressView()
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
    }
}

#Preview {
    ProgressViewWithAlert(showingAlert: .constant(true), alertMessage: "Hatalar")
}

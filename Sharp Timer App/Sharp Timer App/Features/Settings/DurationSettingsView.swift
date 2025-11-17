//
//  DurationSettingsView.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI

struct DurationSettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    @State private var workMinutes: Int
    @State private var restEyesMinutes: Int
    @State private var longRestMinutes: Int
    
    init() {
        _workMinutes = State(initialValue: 25)
        _restEyesMinutes = State(initialValue: 2)
        _longRestMinutes = State(initialValue: 15)
    }
    
    var body: some View {
        Form {
            Section("Timer Durations (minutes)") {
                Stepper("Work Session", value: $workMinutes, in: 1...240)
                Stepper("Rest Your Eyes", value: $restEyesMinutes, in: 1...60)
                Stepper("Long Rest", value: $longRestMinutes, in: 1...240)
            }
            
            Section("Notifications") {
                LabeledContent {
                    Toggle("Enabled", isOn: .constant(true))
                } label: {
                    Label("Show notifications", systemImage: "bell")
                }
            }
            
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                Button("Save") {
                    saveSettings()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .labelStyle(.trailingIcon)
        .padding()
        .frame(width: 300, height: 250)
        .onAppear {
            loadCurrentSettings()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadCurrentSettings() {
        workMinutes = appState.profile.workMinutes
        restEyesMinutes = appState.profile.restEyesMinutes
        longRestMinutes = appState.profile.longRestMinutes
    }
    
    private func saveSettings() {
        appState.updateWorkMinutes(workMinutes)
        appState.updateRestEyesMinutes(restEyesMinutes)
        appState.updateLongRestMinutes(longRestMinutes)
    }
}


#Preview {
    DurationSettingsView()
        .environment(AppState())
        .frame(width: 480, height: 480)
}

//
//  DurationSettingsView.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI

// MARK: - Settings Layout State
struct SettingsLayoutState {
    var popoverWidth: CGFloat
    var isCompact: Bool { popoverWidth < 360 }
    var dynamicTypeSize: DynamicTypeSize
    var layoutMode: LayoutMode { isCompact ? .stacked : .grid }
    
    enum LayoutMode {
        case grid
        case stacked
    }
}

// MARK: - Responsive Settings Components
struct ResponsiveSettingsGrid: View {
    let layoutState: SettingsLayoutState
    let workMinutes: Binding<Int>
    let restEyesMinutes: Binding<Int>
    let longRestMinutes: Binding<Int>
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            // Wide layout: 2-column grid
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Timer Durations")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    DurationStepperRow(label: "Work Session", value: workMinutes, range: 1...240)
                    DurationStepperRow(label: "Long Rest", value: longRestMinutes, range: 1...240)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Settings")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    DurationStepperRow(label: "Rest Your Eyes", value: restEyesMinutes, range: 1...60)
                    
                    NotificationToggleRow()
                }
            }
            .padding(.horizontal)
            
            // Medium layout: Single column with better spacing
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Timer Durations")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    DurationStepperRow(label: "Work Session", value: workMinutes, range: 1...240)
                    DurationStepperRow(label: "Rest Your Eyes", value: restEyesMinutes, range: 1...60)
                    DurationStepperRow(label: "Long Rest", value: longRestMinutes, range: 1...240)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notifications")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    NotificationToggleRow()
                }
            }
            .padding(.horizontal)
            
            // Compact layout: Stacked with minimal spacing
            VStack(spacing: 12) {
                DurationStepperRow(label: "Work Session", value: workMinutes, range: 1...240)
                DurationStepperRow(label: "Rest Your Eyes", value: restEyesMinutes, range: 1...60)
                DurationStepperRow(label: "Long Rest", value: longRestMinutes, range: 1...240)
                
                Divider()
                
                NotificationToggleRow()
            }
            .padding(.horizontal)
        }
    }
}

struct DurationStepperRow: View {
    let label: String
    let value: Binding<Int>
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            
            // Custom stepper implementation to prevent focus loss
            HStack(spacing: 4) {
                Button(action: {
                    if value.wrappedValue > range.lowerBound {
                        value.wrappedValue -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(4)
                .help("Decrease")
                
                Text("\(value.wrappedValue)")
                    .font(.body.monospacedDigit())
                    .frame(width: 30, alignment: .center)
                
                Button(action: {
                    if value.wrappedValue < range.upperBound {
                        value.wrappedValue += 1
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(4)
                .help("Increase")
            }
            .frame(width: 80)
            
            Text("min")
                .font(.body.monospacedDigit())
                .frame(width: 30, alignment: .leading)
        }
    }
}

struct NotificationToggleRow: View {
    var body: some View {
        HStack {
            Label("Show notifications", systemImage: "bell")
                .font(.body)
            Spacer()
            Toggle("", isOn: .constant(true))
                .labelsHidden()
                .help("Toggle notifications")
        }
    }
}

struct DurationSettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    @State private var layoutState = SettingsLayoutState(
        popoverWidth: 300,
        dynamicTypeSize: .medium
    )
    
    @State private var workMinutes: Int
    @State private var restEyesMinutes: Int
    @State private var longRestMinutes: Int
    
    
    init() {
        _workMinutes = State(initialValue: 25)
        _restEyesMinutes = State(initialValue: 2)
        _longRestMinutes = State(initialValue: 15)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content with responsive layout
            ScrollView {
                ResponsiveSettingsGrid(
                    layoutState: layoutState,
                    workMinutes: $workMinutes,
                    restEyesMinutes: $restEyesMinutes,
                    longRestMinutes: $longRestMinutes
                )
                .padding(.vertical, 16)
            }
            
            // Action buttons at bottom
            Divider()
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("Save") {
                    saveSettings()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .frame(minWidth: 280, idealWidth: 320, maxWidth: 400)
        .frame(minHeight: 200, idealHeight: 280, maxHeight: 500)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            loadCurrentSettings()
            updateLayoutState()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didResizeNotification)) { _ in
            updateLayoutState()
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
    
    private func updateLayoutState() {
        // Get the current window width if available
        if let window = NSApp.keyWindow {
            layoutState.popoverWidth = window.frame.width
        } else {
            layoutState.popoverWidth = 320 // Default fallback
        }
        
        // Use a reasonable default for dynamic type size
        layoutState.dynamicTypeSize = .medium
    }
}


#Preview {
    DurationSettingsView()
        .environment(AppState())
        .frame(width: 480, height: 480)
}

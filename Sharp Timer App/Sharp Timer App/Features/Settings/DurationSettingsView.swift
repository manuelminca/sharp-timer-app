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

// MARK: - Auto Start Toggle
struct AutoStartToggleRow: View {
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Label("Auto-start timer on mode change", systemImage: "play.circle")
                .font(BauhausTheme.bodyFont)
                .foregroundColor(BauhausTheme.text)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .help("Toggle auto-start on mode change")
        }
    }
}

// MARK: - Settings Components
struct DurationStepperRow: View {
    let label: String
    let value: Binding<Int>
    let range: ClosedRange<Int>

    var body: some View {
        HStack {
            Text(label)
                .font(BauhausTheme.bodyFont)
                .foregroundColor(BauhausTheme.text)
            Spacer()

            // Custom stepper implementation to prevent focus loss
            HStack(spacing: 4) {
                StepperButton(
                    systemImage: "minus",
                    isEnabled: value.wrappedValue > range.lowerBound,
                    action: {
                        if value.wrappedValue > range.lowerBound {
                            value.wrappedValue -= 1
                        }
                    }
                )
                .help("Decrease")

                Text("\(value.wrappedValue)")
                    .font(BauhausTheme.bodyFont)
                    .foregroundColor(BauhausTheme.text)
                    .frame(width: 30, alignment: .center)

                StepperButton(
                    systemImage: "plus",
                    isEnabled: value.wrappedValue < range.upperBound,
                    action: {
                        if value.wrappedValue < range.upperBound {
                            value.wrappedValue += 1
                        }
                    }
                )
                .help("Increase")
            }
            .frame(width: 80)

            Text("min")
                .font(BauhausTheme.bodyFont)
                .foregroundColor(BauhausTheme.text)
                .frame(width: 30, alignment: .leading)
        }
    }
}

// MARK: - Custom Stepper Button
struct StepperButton: View {
    let systemImage: String
    let isEnabled: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 12, weight: .medium))
            .frame(width: 20, height: 20)
            .background(isPressed ? BauhausTheme.primaryYellow : BauhausTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            .opacity(isEnabled ? 1.0 : 0.5)
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if isEnabled && !isPressed {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        if isEnabled && isPressed {
                            isPressed = false
                            action()
                        }
                    }
            )
    }
}

// MARK: - Responsive Settings Components
struct ResponsiveSettingsGrid: View {
    let layoutState: SettingsLayoutState
    let workMinutes: Binding<Int>
    let restEyesMinutes: Binding<Int>
    let longRestMinutes: Binding<Int>
    let autoStartOnModeChange: Binding<Bool>

    var body: some View {
        ViewThatFits(in: .horizontal) {
            // Wide layout: 2-column grid
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Timer Settings")
                        .font(BauhausTheme.bodyFont)
                        .foregroundColor(BauhausTheme.text)
                        .padding(.bottom, 4)

                    DurationStepperRow(label: "Work Session", value: workMinutes, range: 1...240)
                    DurationStepperRow(label: "Long Rest", value: longRestMinutes, range: 1...240)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Timer Durations")
                        .font(BauhausTheme.bodyFont)
                        .foregroundColor(BauhausTheme.text)
                        .padding(.bottom, 4)

                    DurationStepperRow(label: "Rest Your Eyes", value: restEyesMinutes, range: 1...60)

                    AutoStartToggleRow(isOn: autoStartOnModeChange)
                }
            }
            .padding(.horizontal)

            // Medium layout: Single column with better spacing
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Timer Durations")
                        .font(BauhausTheme.bodyFont)
                        .foregroundColor(BauhausTheme.text)
                        .padding(.bottom, 4)

                    DurationStepperRow(label: "Work Session", value: workMinutes, range: 1...240)
                    DurationStepperRow(label: "Rest Your Eyes", value: restEyesMinutes, range: 1...60)
                    DurationStepperRow(label: "Long Rest", value: longRestMinutes, range: 1...240)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Timer Settings")
                        .font(BauhausTheme.bodyFont)
                        .foregroundColor(BauhausTheme.text)
                        .padding(.bottom, 4)

                    AutoStartToggleRow(isOn: autoStartOnModeChange)
                }
            }
            .padding(.horizontal)

            // Compact layout: Stacked with minimal spacing
            VStack(spacing: 12) {
                DurationStepperRow(label: "Work Session", value: workMinutes, range: 1...240)
                DurationStepperRow(label: "Rest Your Eyes", value: restEyesMinutes, range: 1...60)
                DurationStepperRow(label: "Long Rest", value: longRestMinutes, range: 1...240)

                Divider()

                AutoStartToggleRow(isOn: autoStartOnModeChange)
            }
            .padding(.horizontal)
        }
    }
}

struct DurationSettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var workMinutes: Int
    @State private var restEyesMinutes: Int
    @State private var longRestMinutes: Int
    @State private var autoStartOnModeChange: Bool

    init() {
        // Initialize with default values - will be updated in onAppear
        _workMinutes = State(initialValue: 25)
        _restEyesMinutes = State(initialValue: 2)
        _longRestMinutes = State(initialValue: 15)
        _autoStartOnModeChange = State(initialValue: false)
    }
    
    var body: some View {
        ZStack {
            // Background with decorative Bauhaus elements
            BauhausTheme.background
                .ignoresSafeArea()
            
            // Decorative geometric elements
            decorativeBackgroundElements
            
            // Main content card
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Duration controls
                durationControlsSection
                
                // Auto-start toggle
                autoStartToggleSection
                
                // Action buttons
                actionButtonsSection
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(BauhausTheme.surface)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(12)
        }
        .frame(width: 320, height: 400) // Increased width for better label spacing
        .onAppear {
            loadCurrentSettings()
        }
    }
    
    // MARK: - Decorative Background Elements
    private var decorativeBackgroundElements: some View {
        ZStack {
            // Top left circle
            Circle()
                .fill(BauhausTheme.primaryBlue.opacity(0.2))
                .frame(width: 64, height: 64)
                .position(x: 40, y: 40)
            
            // Bottom right square
            Rectangle()
                .fill(BauhausTheme.primaryRed.opacity(0.2))
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(45))
                .position(x: -40, y: -40)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(BauhausTheme.primaryBlue)
                .frame(width: 8, height: 32)
            
            Image(systemName: "gear")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(BauhausTheme.primaryBlue)
                .clipShape(RoundedRectangle(cornerRadius: 0))
            
            Text("Settings")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(BauhausTheme.text)
                .textCase(.uppercase)
                .tracking(2)
            
            Spacer()
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Duration Controls Section
    private var durationControlsSection: some View {
        VStack(spacing: 0) {
            BauhausDurationControl(
                label: "Work",
                value: $workMinutes,
                color: BauhausTheme.primaryRed
            )
            
            BauhausDurationControl(
                label: "Rest",
                value: $restEyesMinutes,
                color: BauhausTheme.primaryBlue
            )
            
            BauhausDurationControl(
                label: "Long Rest",
                value: $longRestMinutes,
                color: BauhausTheme.primaryYellow
            )
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Auto-Start Toggle Section
    private var autoStartToggleSection: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(BauhausTheme.text.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal, 16)
            
            Button(action: {
                autoStartOnModeChange.toggle()
            }) {
                HStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(autoStartOnModeChange ? BauhausTheme.primaryRed : BauhausTheme.background)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: 16, height: 16)
                                    .clipShape(PentagonShape())
                                    .scaleEffect(autoStartOnModeChange ? 1.0 : 0.0)
                                    .animation(.easeInOut(duration: 0.3), value: autoStartOnModeChange)
                            )
                        
                        Text("Auto-start")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(BauhausTheme.text)
                            .textCase(.uppercase)
                            .tracking(1)
                    }
                    
                    Spacer()
                    
                    // Custom toggle
                    Rectangle()
                        .fill(autoStartOnModeChange ? BauhausTheme.primaryRed : BauhausTheme.text)
                        .frame(width: 40, height: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            Circle()
                                .fill(.white)
                                .frame(width: 16, height: 16)
                                .offset(x: autoStartOnModeChange ? 10 : -10)
                                .animation(.easeInOut(duration: 0.3), value: autoStartOnModeChange)
                        )
                }
                .padding(.vertical, 16)
            }
            .buttonStyle(PlainButtonStyle())
            
            Rectangle()
                .fill(BauhausTheme.text.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal, 16)
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(BauhausActionButtonStyle(
                backgroundColor: .clear,
                hoverColor: BauhausTheme.background,
                borderColor: BauhausTheme.text
            ))
            
            Button("Save") {
                saveSettings()
                dismiss()
            }
            .buttonStyle(BauhausActionButtonStyle(
                backgroundColor: BauhausTheme.primaryBlue,
                hoverColor: BauhausTheme.primaryRed
            ))
        }
    }
    
    // MARK: - Private Methods
    
    private func loadCurrentSettings() {
        workMinutes = appState.profile.workMinutes
        restEyesMinutes = appState.profile.restEyesMinutes
        longRestMinutes = appState.profile.longRestMinutes
        autoStartOnModeChange = appState.profile.autoStartOnModeChange ?? false
    }
    
    private func saveSettings() {
        appState.updateWorkMinutes(workMinutes)
        appState.updateRestEyesMinutes(restEyesMinutes)
        appState.updateLongRestMinutes(longRestMinutes)
        appState.updateAutoStartOnModeChange(autoStartOnModeChange)
    }
    
    
}

// MARK: - Bauhaus Duration Control
struct BauhausDurationControl: View {
    let label: String
    @Binding var value: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(color)
                .frame(width: 6, height: 24)
            
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(BauhausTheme.text)
                .textCase(.uppercase)
                .tracking(0)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 130, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    if value > 1 {
                        value -= 1
                    }
                }) {
                    Rectangle()
                        .fill(BauhausTheme.text)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "minus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("\(value)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(BauhausTheme.text)
                    .frame(width: 28, height: 24)
                
                Button(action: {
                    if value < 240 {
                        value += 1
                    }
                }) {
                    Rectangle()
                        .fill(BauhausTheme.text)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Text("min")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(BauhausTheme.text.opacity(0.6))
                .textCase(.uppercase)
                .tracking(1)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            Rectangle()
                .fill(BauhausTheme.text.opacity(0.05))
                .frame(height: 1)
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
    }
}


#Preview {
    DurationSettingsView()
        .environment(AppState())
        .frame(width: 480, height: 480)
}

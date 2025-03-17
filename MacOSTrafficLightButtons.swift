

import SwiftUI
import AppKit

// TODO:
// - Get SVG icons working
// - Make Colors more adaptable

// MARK: - MacOS Buttons (not sure what to call this)
struct MacOSTrafficLightButtons: View {
    @State private var isHovered = false // Displays window icons
    @State private var isFocused = false // Swaps between gray and colord button
    @State private var isFullscreen = false // This is used to hide the fake buttons when in full screan

    var body: some View {
        HStack {
            MacOSTrafficLightButton(hoverState: isHovered, isFocused: isFocused, buttonType: .close) {
                NSApp.keyWindow?.close()
            }
            MacOSTrafficLightButton(hoverState: isHovered, isFocused: isFocused, buttonType: .minimize) {
                NSApp.keyWindow?.miniaturize(nil)
            }
            MacOSTrafficLightButton(hoverState: isHovered, isFocused: isFocused, buttonType: .fullscreen) {
                NSApp.keyWindow?.toggleFullScreen(nil)
            }
        }
        .onHover { hovering in
            isHovered = hovering
        }
        .frame(width: 52, height: 20)
        .padding()
        .opacity(isFullscreen ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: isFullscreen)
        .onAppear {
            observeWindowState()
        }
    }

    // Checks window state in order to update the buttons state
    private func observeWindowState() {
        let center = NotificationCenter.default
        
        center.addObserver(forName: NSWindow.didBecomeKeyNotification, object: nil, queue: .main) { _ in
            isFocused = true
        }

        center.addObserver(forName: NSWindow.didResignKeyNotification, object: nil, queue: .main) { _ in
            isFocused = false
        }

        center.addObserver(forName: NSWindow.didEnterFullScreenNotification, object: nil, queue: .main) { _ in
            isFullscreen = true
        }

        center.addObserver(forName: NSWindow.didExitFullScreenNotification, object: nil, queue: .main) { _ in
            isFullscreen = false
        }
    }
}
// MARK: - Button Component
struct MacOSTrafficLightButton: View {
    enum WindowButton {
        case close
        case minimize
        case fullscreen
    }
    
    var hoverState: Bool
    var isFocused: Bool
    let buttonType: WindowButton
    let action: () -> Void
    
    let idleFillColor: Color = Color(red: 210/255, green: 210/255, blue: 210/255)
    let strokeIdleColor: Color = Color(red: 195/255, green: 195/255, blue: 195/255)
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .center) {
                Circle()
                    .fill(fillColor)
                    .overlay(
                        Circle()
                            .stroke(strokeColor, lineWidth: 1)
                            .opacity(0.5)
                    )
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 6, height: 6)
                    .opacity(hoverState ? 0.6 : 0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 12.5, height: 12.5)
    }
    
    // MARK: - Colour Configuration
    private var fillColor: Color {
        switch buttonType {
        case .close: return ( isFocused || hoverState ) ? Color(red: 236/255, green: 106/255, blue: 94/255) : idleFillColor
        case .minimize: return ( isFocused || hoverState )  ? Color(red: 254/255, green: 188/255, blue: 46/255) : idleFillColor
        case .fullscreen: return ( isFocused || hoverState )  ? Color(red: 40/255, green: 200/255, blue: 65/255) : idleFillColor
        }
    }
    
    private var strokeColor: Color {
        switch buttonType {
        case .close: return ( isFocused || hoverState )  ? Color(red: 208/255, green: 78/255, blue: 69/255) : strokeIdleColor
        case .minimize: return ( isFocused || hoverState )  ? Color(red: 224/255, green: 156/255, blue: 21/255) : strokeIdleColor
        case .fullscreen: return ( isFocused || hoverState )  ? Color(red: 21/255, green: 169/255, blue: 31/255) : strokeIdleColor
        }
    }
    
    // Make sure to add the images to your assets
    private var imageName: String {
        switch buttonType {
        case .close: return "close"
        case .minimize: return "minimize"
        case .fullscreen: return "resize"
        }
    }
}

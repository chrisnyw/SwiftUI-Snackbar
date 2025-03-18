//
//  SnackbarProperties.swift
//  SpotlightIndexDemo
//
//  Created by Chris Ng on 2025-03-12.
//

import SwiftUI

public extension Snackbar {
    typealias ActionHanlder = () -> Void
    
    public struct Decorator: Equatable {
        /// Set the snackbar maximum width
        let width: Double
        /// Set snackbar background color
        let backgroundColor: Color
        /// Set the title text color
        let titleTextColor: Color
        /// Set the message text color
        let messageTextColor: Color
        
        public init(
            width: Double = .infinity,
            backgroundColor: Color = Color(UIColor.secondarySystemBackground),
            titleTextColor: Color = .primary,
            messageTextColor: Color = .primary
        ) {
            self.width = width
            self.backgroundColor = backgroundColor
            self.titleTextColor = titleTextColor
            self.messageTextColor = messageTextColor
        }
    }
    
    public enum Icon: Hashable {
        case none
        case error
        case warning
        case success
        case info
        case system(imageName: String, Color: Color)
        case custom(imageName: String)
    }
    
    public enum Action: Hashable {
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .none:
                break
            case .xMark(let color):
                hasher.combine(color)
            case .text(let string, let color, _):
                hasher.combine(string)
                hasher.combine(color)
            case .systemImage(let image, let color, _):
                hasher.combine(image)
                hasher.combine(color)
            case .imageName(let image, _):
                hasher.combine(image)
            }
        }
        
        public static func == (lhs: Snackbar.Action, rhs: Snackbar.Action) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none):
                return true
            case (.xMark(let lhsColor), .xMark(let rhColor)):
                return lhsColor == rhColor
            case (.text(let lhsText, let lhsColor, _), .text(let rhsText, let rhsColor, _)):
                return lhsText == rhsText && lhsColor == rhsColor
            case (.systemImage(let lhsImage, let lhsColor, _), .systemImage(let rhsImage, let rhsColor, _)):
                return lhsImage == rhsImage && lhsColor == rhsColor
            case (.imageName(let lhsImage, _), .imageName(let rhsImage, _)):
                return lhsImage == rhsImage
            default:
                return false
            }
        }
        
        case none
        case xMark(Color)
        case text(String, Color, ActionHanlder)
        case systemImage(String, Color, ActionHanlder)
        case imageName(String, ActionHanlder)
    }
    
    public enum Position: Hashable, CaseIterable {
        public static var allCases: [Snackbar.Position] = [
            .top(offset: 0),
            .center,
            .bottom(offset: 0)
        ]
        
        case top(offset: Double)
        case center
        case bottom(offset: Double)
    }
    
    public enum Duration: Hashable {
        case fixed(seconds: TimeInterval)
        case infinite
    }
    
    public struct Properties: Hashable {
        /// Configure the snackbar position
        let position: Position
        /// Configure the duration of snackbar to be displayed
        let duration: Duration
        /// Disable haptic vibration when message is showing up
        let disableHapticVibration: Bool
        
        public init(
            position: Snackbar.Position = .top(offset: 0),
            duration: Snackbar.Duration = .fixed(seconds: 3),
            disableHapticVibration: Bool = false
        ) {
            self.position = position
            self.duration = duration
            self.disableHapticVibration = disableHapticVibration
        }
    }
}

extension Snackbar.Decorator {
    public static let `default` = Self()
}

extension Snackbar.Properties {
    public static let `default` = Self()
}

extension Snackbar.Icon {
    public var description: String {
        switch self {
        case .none: return "None"
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return "Info"
        case .success: return "Success"
        case .system(let imageName, _): return "System_\(imageName)"
        case .custom(let imageName): return  "Custom_\(imageName)"
        }
    }
    
    var themeColor: Color {
        switch self {
        case .none,
                .custom:
            return Color.primary
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        case .system(_, let color):
            return color
        }
    }
    
    var iconFileName: String? {
        switch self {
        case .none,
                .system,
                .custom:
            return nil
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
    
    var image: Image? {
        switch self {
        case .none:
            return nil
        case .info,
                .warning,
                .success,
                .error:
            if let imageName = self.iconFileName {
                return Image(systemName: imageName)
            }
        case .system(let imageName, _):
            return Image(systemName: imageName)
        case .custom(let imageName):
            return Image(imageName)
        }
        return nil
    }
}

extension Snackbar.Action {
    
}
    
extension Snackbar.Position {
    public var description: String {
        switch self {
        case .top(let offset): return "Top: \(offset)"
        case .center: return "Center"
        case .bottom(let offset): return "Bottom: \(offset)"
        }
    }
    
    var alignment: Alignment {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
    
    var yOffset: CGFloat {
        switch self {
        case .top(let offset),
                .bottom(let offset):
            return offset
        case .center: return 0
        }
    }
}

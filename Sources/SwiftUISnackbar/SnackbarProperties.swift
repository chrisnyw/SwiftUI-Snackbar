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
        let backgroundColor: Color
        let foregroundColor: Color
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
    
    public enum Position: String, CaseIterable {
        case top
        case center
        case bottom
    }
    
    public enum Duration: Hashable {
        case fixed(seconds: TimeInterval)
        case infinite
    }
}

extension Snackbar.Decorator {
    public static let `default` = Self(backgroundColor: Color(UIColor.secondarySystemBackground), foregroundColor: .primary)
}

extension Snackbar.Icon {
    public var title: String {
        switch self {
        case .none: return "None"
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return "Info"
        case .success: return "Success"
        case .system: return "System"
        case .custom: return  "Custom"
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
    var alignment: Alignment {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
    
    var yOffset: CGFloat {
        switch self {
        case .top: return 0
        case .center: return 0
        case .bottom: return 0
        }
    }
}

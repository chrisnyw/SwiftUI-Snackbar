//
//  Snackbar.swift
//  SpotlightIndexDemo
//
//  Created by Chris Ng on 2025-03-12.
//

import Foundation

public struct Snackbar: Equatable {
    let title: String?
    let message: String
    let width: Double
    let icon: Icon
    let action: Action
    let position: Position
    let decorator: Decorator
    let duration: Duration
    
    public init(
        title: String? = nil,
        message: String,
        width: Double = .infinity,
        icon: Icon,
        action: Action = .none,
        position: Position = .bottom,
        decorator: Decorator = .default,
        duration: Duration = .fixed(seconds: 3)
    ) {
        self.title = title
        self.message = message
        self.width = width
        self.icon = icon
        self.action = action
        self.position = position
        self.decorator = decorator
        self.duration = duration
    }
}

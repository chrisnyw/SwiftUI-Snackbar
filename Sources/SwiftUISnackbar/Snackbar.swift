//
//  Snackbar.swift
//  SpotlightIndexDemo
//
//  Created by Chris Ng on 2025-03-12.
//

import Foundation

public struct Snackbar: Equatable, Sendable {
    /// Optional title text
    let title: String?
    /// Compulsory message text
    let message: String
    /// Properties of snackbar
    let properties: Properties
    /// An enum icon to be set to snackbar on the left side
    let icon: Icon
    /// Configure the action on the right side
    let action: Action
    /// Configure the color of background and texts
    let decorator: Decorator
    
    public init(
        title: String? = nil,
        message: String,
        properties: Properties = .default,
        icon: Icon = .none,
        action: Action = .none,
        decorator: Decorator = .default
    ) {
        self.title = title
        self.message = message
        self.properties = properties
        self.icon = icon
        self.action = action
        self.decorator = decorator
    }
}

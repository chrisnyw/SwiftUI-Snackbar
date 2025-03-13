//
//  SnackbarDemoView.swift
//  SwiftUISnackbarDemo
//
//  Created by Chris Ng on 2025-03-12.
//

import SwiftUI
import SwiftUISnackbar

struct SnackbarDemoView: View {
    private let allStyles: [Snackbar.Icon] = [
        .none,
        .info,
        .success,
        .warning,
        .error,
        .system(imageName: "gear", Color: .blue),
        .custom(imageName: "natural")
    ]
    private let durations: [Snackbar.Duration] = [.fixed(seconds: 3), .fixed(seconds: 10), .infinite]
    private let actions: [Snackbar.Action] = [
        .none,
        .xMark(.red),
        .text("Action", .orange, { print("tapped action text") }),
        .systemImage("gear", .brown, { print("tapped system image") }),
        .imageName("natural", { print("tapped nutural image") } )
    ]
    
    @State private var title: String = "Title"
    @State private var message: String = "Your Snackbar message content!!"
    @State private var snackbarPosition: Snackbar.Position = .top
    @State private var snackbarStyle: Snackbar.Icon = .none
    @State private var duration: Snackbar.Duration = .fixed(seconds: 3)
    @State private var action: Snackbar.Action = .none
    
    @State private var snackbar: Snackbar?

    var body: some View {
        VStack {
            
            HStack {
                Text("Position:")
                Picker("Position", selection: $snackbarPosition) {
                    ForEach(Snackbar.Position.allCases, id: \.self) { position in
                        Text(position.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            HStack {
                Text("Icon:")
                Picker("Icon", selection: $snackbarStyle) {
                    ForEach(allStyles, id: \.self) { style in
                        Text(style.title.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            HStack {
                Text("Duration:")
                Picker("Duration", selection: $duration) {
                    ForEach(durations, id: \.self) { duration in
                        switch duration {
                        case .fixed(let seconds):
                            Text("\(Int(seconds))")
                        case .infinite:
                            Text("Infinite")
                        }
                        
                    }
                }
                .pickerStyle(.segmented)
            }
            
            HStack {
                Text("Action:")
                Picker("Action", selection: $action) {
                    ForEach(actions, id: \.self) { action in
                        actionRow(action: action)
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            HStack {
                Text("Title:")
                TextField("Title", text: $title)
                    .border(.black, width: 1)
            }
            
            HStack {
                Text("Message:")
                TextEditor(text: $message)
                    .border(.black, width: 1)
                    .frame(maxHeight: 60)
            }
            
            Button(
                action: {
                    snackbar = Snackbar(
                        title: title,
                        message: message,
                        icon: snackbarStyle,
                        action: action,
                        position: snackbarPosition,
                        decorator: .default,
                        duration: duration
                    )
                },
                label: {
                Text("Show Snackbar")
            })
        }
        .padding()
        .snackbarView(snackbar: $snackbar)
    }
    
    @ViewBuilder func actionRow(action: Snackbar.Action) -> some View {
        switch action {
        case .none:
            Text("None")
        case .xMark:
            Text("xMark")
        case .text(let title, _, _):
            Text("Text: \(title)")
        case .systemImage(let imageName, _, _):
            Text("System: \(imageName)")
        case .imageName(let imageName, _):
            Text("Custom: \(imageName)")
        }
    }
}

#Preview {
    SnackbarDemoView()
}

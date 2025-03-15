//
//  SnackbarDemoView.swift
//  SwiftUISnackbarDemo
//
//  Created by Chris Ng on 2025-03-12.
//

import SwiftUI
import SwiftUISnackbar

struct SnackbarDemoView: View {
    private let allIcons: [Snackbar.Icon] = [
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
        .xMark(.primary),
        .text("Action", .orange, { print("tapped action text") }),
        .systemImage("gear", .brown, { print("tapped system image") }),
        .imageName("natural", { print("tapped nutural image") } )
    ]
    
    @State private var title: String = "Title"
    @State private var message: String = "Your Snackbar message content!!"
    @State private var snackbarPosition: Snackbar.Position = .top
    @State private var snackbarIcon: Snackbar.Icon = .none
    @State private var duration: Snackbar.Duration = .fixed(seconds: 3)
    @State private var action: Snackbar.Action = .none
    
    @State private var snackbar: Snackbar?
    
    var body: some View {
        ScrollView {
            section(title: "Custom Snackbar", content: { customSnackbar })
            section(title: "Demo Snackbar", content: { demoSnackbars })
        }
        .snackbarView(snackbar: $snackbar)
        
    }
    
    @ViewBuilder
    private var customSnackbar: some View {
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
            Spacer()
            Picker("Icon:", selection: $snackbarIcon) {
                ForEach(allIcons, id: \.self) { icon in
                    Text(icon.description.capitalized)
                }
            }
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
            Spacer()
            Picker("Action:", selection: $action) {
                ForEach(actions, id: \.self) { action in
                    actionRow(action: action)
                }
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
                    properties:
                        Snackbar.Properties(
                            position: snackbarPosition,
                            duration: duration
                        ),
                    icon: snackbarIcon,
                    action: action,
                    decorator: .default
                )
            },
            label: {
                Text("Show Snackbar")
            })
        
    }
    
    @ViewBuilder func section(title: String, content: () -> some View) -> some View {
        VStack {
            Text(title)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(.black, lineWidth: 1)
        )
    }
    
    
    @ViewBuilder var demoSnackbars: some View {
        VStack {
            demoButton(
                title: "Demo Success",
                color: .green,
                inputSnackbar: Snackbar(
                    title: "Demo 1",
                    message: "Success!",
                    properties:
                        Snackbar.Properties(
                            position: .bottom,
                            duration: .fixed(seconds: 5)
                        ),
                    icon: .system(imageName: "info.circle.fill", Color: .white),
                    action: .none,
                    decorator: Snackbar.Decorator(
                        backgroundColor: .green,
                        titleTextColor: .white,
                        messageTextColor: .white
                    )
                )
            )
            
            demoButton(
                title: "Demo Error",
                color: .red,
                inputSnackbar: Snackbar(
                    title: "Demo 2",
                    message: "Error!",
                    properties:
                        Snackbar.Properties(
                            position: .bottom,
                            duration: .fixed(seconds: 5)
                        ),
                    icon: .system(imageName: "xmark.circle.fill", Color: .white),
                    action: .none,
                    decorator: Snackbar.Decorator(
                        backgroundColor: .red,
                        titleTextColor: .white,
                        messageTextColor: .white
                    )
                )
            )
            
            demoButton(
                title: "Demo Warning",
                color: .yellow,
                inputSnackbar: Snackbar(
                    title: "Demo 3",
                    message: "Warning!",
                    properties:
                        Snackbar.Properties(
                            position: .top,
                            duration: .fixed(seconds: 5)
                        ),
                    icon: .system(imageName: "exclamationmark.triangle.fill", Color: .white),
                    action: .text("Show me", .white, { print("tapped warning") }),
                    decorator: Snackbar.Decorator(
                        backgroundColor: .yellow,
                        titleTextColor: .white,
                        messageTextColor: .white
                    )
                )
            )
            
            demoButton(
                title: "Demo Basic",
                color: .gray,
                inputSnackbar: Snackbar(title: "Demo Basic", message: "Message!")
            )
            
            demoButton(
                title: "Demo Full",
                color: .black,
                inputSnackbar: Snackbar(
                    title: "Demo Full",
                    message: "Your message going here!",
                    properties:
                        Snackbar.Properties(
                            position: .bottom,
                            duration: .fixed(seconds: 5),
                            disableHapticVibration: true
                        ),
                    icon: .system(imageName: "info.circle.fill", Color: .white),
                    action: .text("Tap me", .red, { print("tapped me") }),
                    decorator: Snackbar.Decorator(
                        backgroundColor: .black,
                        titleTextColor: .orange,
                        messageTextColor: .yellow
                    )
                )
            )
            
        }
    }
    
    @ViewBuilder func demoButton(
        title: String,
        color: Color,
        inputSnackbar: Snackbar
    ) -> some View {
        Button(
            action: { snackbar = inputSnackbar },
            label: { Text(title).padding(5).foregroundStyle(.primary) }
        )
        .background(color)
        .cornerRadius(5)
        .foregroundStyle(.white)
    }
    
    @ViewBuilder func demoButton(color: Color, button: () -> some View) -> some View {
        button()
            .background(color)
            .cornerRadius(5)
            .foregroundStyle(.white)
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
            Text("System Image: \(imageName)")
        case .imageName(let imageName, _):
            Text("Custom Image: \(imageName)")
        }
    }
}

#Preview {
    SnackbarDemoView()
}

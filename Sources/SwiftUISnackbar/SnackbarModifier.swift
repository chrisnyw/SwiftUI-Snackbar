//
//  SnackbarModifier.swift
//  SpotlightIndexDemo
//
//  Created by Chris Ng on 2025-03-12.
//

import SwiftUI

struct SnackbarModifier: ViewModifier {
    
    @Binding var snackbar: Snackbar?
    @State private var workItem: DispatchWorkItem?
    @State private var translation: CGSize = .zero
    @State private var isDragging: Bool = false
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: snackbar?.properties.position.alignment ?? .center) {
                ZStack {
                    mainSnackbarView()
                        .offset(y: animatedYOffset)
                        .opacity(animatedOpacity)
                }.animation(.spring(), value: snackbar)
            }
            .onChange(of: snackbar, initial: false) { _, _ in
                showSnackbar()
            }
    }
    
    private var animatedYOffset: CGFloat {
        return (snackbar?.properties.position.yOffset ?? 0) + translation.height / 10
    }
    
    private var animatedOpacity: Double {
        let opaque = 1.0
        guard let snackbar, isDragging, isDismissing(translation: translation) else { return opaque }
        return 1.0 / abs(translation.height / 10)
    }
    
    @ViewBuilder func mainSnackbarView() -> some View {
        if let snackbar = snackbar {
            SnackbarView(snackbar: snackbar) {
                dismissSnackbar(isUserAction: true)
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation {
                            translation = value.translation
                            isDragging = true
                        }
                    })
                    .onEnded({ value in
                        withAnimation {
                            if !isDismissing(translation: value.translation) {
                                translation = .zero
                                isDragging = false
                            }
                            dismissSnackbarIsNecessary(lastTranslation: value.translation)
                            
                        }
                    })
            )

        }
    }
    
    private func showSnackbar() {
        guard let snackbar else { return }
        
        // reset all properties
        isDragging = false
        translation = .zero
        
        if snackbar.properties.disableHapticVibration == false {
            UIImpactFeedbackGenerator(style: .light)
                .impactOccurred()
        }
        
        if case let .fixed(seconds) = snackbar.properties.duration, seconds > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissSnackbar(isUserAction: false)
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: task)
        }
    }
    
    private func isDismissing(translation: CGSize) -> Bool {
        guard let snackbar else { return false }
        switch snackbar.properties.position {
        case .top:
            return translation.height < 0
        case .center:
            return translation.height != 0
        case .bottom:
            return translation.height > 0
        }
    }
    
    private func dismissSnackbarIsNecessary(lastTranslation: CGSize) {
        guard isDismissing(translation: lastTranslation) else { return }
        dismissSnackbar(isUserAction: false)
    }
    
    private func dismissSnackbar(isUserAction: Bool) {
        let tempAction = snackbar?.action
        withAnimation {
            snackbar = nil
        }
        
        workItem?.cancel()
        workItem = nil
        
        if let action = tempAction, isUserAction {
            callback(snackbarAction: action)
        }
    }
    
    private func callback(snackbarAction: Snackbar.Action) {
        switch snackbarAction {
        case .none,
                .xMark:
            break
        case .text(_, _, let actionHanlder),
                .systemImage(_, _, let actionHanlder),
                .imageName(_, let actionHanlder):
            actionHanlder()
        }
    }
}

extension View {
    
    public func snackbarView(snackbar: Binding<Snackbar?>) -> some View {
        self.modifier(SnackbarModifier(snackbar: snackbar))
    }
}

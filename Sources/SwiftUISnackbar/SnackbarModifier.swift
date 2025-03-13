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
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: snackbar?.position.alignment ?? .center) {
                ZStack {
                    mainSnackbarView()
                        .offset(y: snackbar?.position.yOffset ?? 0)
                }.animation(.spring(), value: snackbar)
            }
            .onChange(of: snackbar, initial: false) { _, _ in
                showSnackbar()
            }
    }
    
    @ViewBuilder func mainSnackbarView() -> some View {
        if let snackbar = snackbar {
            SnackbarView(snackbar: snackbar) {
                dismissSnackbar(isUserAction: true)
            }
        }
    }
    
    private func showSnackbar() {
        guard let snackbar = snackbar else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if case let .fixed(seconds) = snackbar.duration, seconds > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissSnackbar(isUserAction: false)
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: task)
        }
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

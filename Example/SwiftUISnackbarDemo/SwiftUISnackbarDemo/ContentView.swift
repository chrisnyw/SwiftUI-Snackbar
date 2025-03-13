//
//  ContentView.swift
//  SwiftUISnackbarDemo
//
//  Created by Chris Ng on 2025-02-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            SnackbarDemoView()
        }
        .padding()
//        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

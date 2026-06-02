//
//  ContentView.swift
//  WheresEz
//
//  Created by GARY CROSBY on 2/6/2026.
//

import SwiftUI
import WezImplementations

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("WezKit linked: \(WezImplementations.dependsOn)")        }
        .padding()
    }
}

#Preview {
    ContentView()
}

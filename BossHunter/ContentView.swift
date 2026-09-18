//
//  ContentView.swift
//  BossHunter
//
//  Created by Rostislav on 18.09.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            topBar
            bossBlock
            unitsBlock
        }
        .padding()
    }

    // Top bar: level + gold placeholders (units 2/4 will wire these up)
    private var topBar: some View {
        VStack {
            HStack {
                Text("Gold: 0")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text("Level: 1")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack {
                Text("Old Iron King")
                Spacer().frame(height: 8)
                Text("350 / 1000")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // Boss block: tap target goes here (unit 3)
    private var bossBlock: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.red.opacity(0.3))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Text("Boss")
                    .font(.largeTitle)
            }
    }

    // Shop block: unit slots go here (unit 4)
    private var unitsBlock: some View {
        VStack {
            Text("Units")
                .font(.headline)
            HStack(spacing: 12) {
                // Placeholder slots; unit 4 wires these to real units
                ForEach(0..<4) { _ in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.blue.opacity(0.3))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            HStack {
                // Small button to open the shop for this unit slot
                Button("Shop") {
                    // TODO: open unit shop (unit 4)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                // Small button to open the shop for this unit slot
                Button("Weapons") {
                    // TODO: open unit shop (unit 4)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}

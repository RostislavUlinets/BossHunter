//
//  GameStateTests.swift
//  BossHunterTests
//
//  Created by Rostislav on 18.09.2026.
//

import Foundation
import Testing
@testable import BossHunter

@MainActor
struct GameStateTests {
    private func freshDefaults() -> UserDefaults {
        let defaults = UserDefaults(suiteName: "BossHunterTests")!
        defaults.removeObject(forKey: "BossHunter.gold")
        return defaults
    }

    @Test func startsWithZeroGold() {
        let state = GameState(defaults: freshDefaults())
        #expect(state.gold == 0)
    }

    @Test func addGoldIncreasesBalance() {
        let state = GameState(defaults: freshDefaults())
        state.addGold(50)
        #expect(state.gold == 50)
    }

    @Test func spendGoldSucceedsWhenAffordable() {
        let state = GameState(defaults: freshDefaults())
        state.addGold(50)
        #expect(state.spendGold(30) == true)
        #expect(state.gold == 20)
    }

    @Test func spendGoldFailsWhenUnaffordable() {
        let state = GameState(defaults: freshDefaults())
        state.addGold(10)
        #expect(state.spendGold(30) == false)
        #expect(state.gold == 10)
    }

    @Test func goldPersistsAcrossInstances() {
        let defaults = freshDefaults()
        let first = GameState(defaults: defaults)
        first.addGold(75)
        let second = GameState(defaults: defaults)
        #expect(second.gold == 75)
    }
}

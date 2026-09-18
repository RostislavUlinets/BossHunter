//
//  GameState.swift
//  BossHunter
//
//  Created by Rostislav on 18.09.2026.
//

import Combine
import Foundation

/// Single source of truth for game progress. Views read its published state
/// and call its methods; they never mutate game values directly.
@MainActor
final class GameState: ObservableObject {
    @Published private(set) var gold: Int

    private let defaults: UserDefaults
    private static let goldKey = "BossHunter.gold"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.gold = defaults.integer(forKey: Self.goldKey)
    }

    func addGold(_ amount: Int) {
        guard amount >= 0, gold <= Int.max - amount else { return }
        gold += amount
        save()
    }

    /// Spends gold when affordable. Returns whether the purchase succeeded.
    @discardableResult
    func spendGold(_ amount: Int) -> Bool {
        guard amount >= 0, amount <= gold else { return false }
        gold -= amount
        save()
        return true
    }

    private func save() {
        defaults.set(gold, forKey: Self.goldKey)
    }
}

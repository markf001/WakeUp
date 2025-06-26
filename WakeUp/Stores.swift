//
//  Stores.swift
//  WakeUp
//
//  Created by Luke Albrecht on 26/6/2025.
//

import Foundation

enum EmojiTag: String, CaseIterable {
    case good, bad, better
}

struct EmojiStore {
    private let emojisByTag: [EmojiTag: [String]] = [
        .good: ["🌞", "😊", "😌", "☕️", "🌻", "😴", "🌤️"],
        .bad: ["🌞", "😊", "😌", "☕️", "🌻", "😴", "🌤️"],
        .better: ["🌞", "😊", "😌", "☕️", "🌻", "😴", "🌤️"]
    ]

    private let textsByTag: [EmojiTag: [String]] = [
        .good: [
            "Good morning!",
            "Fresh start!",
            "Rise up!",
            "New day!",
            "Let’s go!"
        ]
,
        .bad: [
            "Still tired?",
            "Try again.",
            "Keep going.",
            "Deep breaths."
        ],
        .better: [
            "Crush it!",
            "On fire!",
            "Own it!",
            "Let’s win!",
            "Unstoppable!"
        ]
    ]

    func randomEmoji(for tag: EmojiTag) -> String? {
        return emojisByTag[tag]?.randomElement()
    }

    func randomText(for tag: EmojiTag) -> String? {
        guard let options = textsByTag[tag], !options.isEmpty else { return nil }
        let phrase = options.randomElement() ?? ""
        return phrase.replacingOccurrences(of: "{timeOfDay}", with: Self.currentTimeOfDay())
    }

    static func currentTimeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "morning"
        case 12..<17: return "afternoon"
        case 17..<21: return "evening"
        default: return "night"
        }
    }
}

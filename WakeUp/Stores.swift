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
        .good: ["😊", "😄", "👍", "🌞"],
        .bad: ["😢", "😠", "👎", "🌧️"],
        .better: ["😎", "🔥", "💪", "🚀"]
    ]

    private let textsByTag: [EmojiTag: [String]] = [
        .good: [
            "Hope you're having a nice {timeOfDay}!",
            "Wishing you a peaceful {timeOfDay}.",
            "It's a great {timeOfDay}, isn't it?"
        ],
        .bad: [
            "Ugh... rough {timeOfDay}, huh?",
            "Not every {timeOfDay} can be perfect.",
            "Hang in there this {timeOfDay}."
        ],
        .better: [
            "Things are looking up this {timeOfDay}!",
            "You're doing awesome this {timeOfDay}!",
            "Let's crush the {timeOfDay}!"
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

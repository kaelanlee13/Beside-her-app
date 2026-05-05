//
//  ReadableArticle+Tip.swift
//  BesideHer
//
//  Adapts a Tip into the editorial ReadableArticle shape so every tip can be
//  rendered by ArticleReaderView.
//

import Foundation

extension ReadableArticle {

    /// Builds a "leaf" article — used inside another article's related list.
    /// Has no further related articles to keep the model finite.
    static func leaf(from tip: Tip) -> ReadableArticle {
        let paragraphs = paragraphs(from: tip.content)
        return ReadableArticle(
            id: tip.id,
            category: tip.categoryDisplayName,
            readTimeMinutes: readTimeMinutes(for: tip.content),
            title: tip.title,
            authorName: defaultAuthor,
            publishedDate: defaultPublishLabel,
            pullQuote: nil,
            paragraphs: paragraphs,
            relatedArticles: []
        )
    }

    /// Builds a full article including up to 3 sibling tips from the same
    /// category as related reading.
    static func article(from tip: Tip, siblings: [Tip]) -> ReadableArticle {
        let related = siblings
            .filter { $0.id != tip.id }
            .prefix(3)
            .map { ReadableArticle.leaf(from: $0) }

        let paragraphs = paragraphs(from: tip.content)
        return ReadableArticle(
            id: tip.id,
            category: tip.categoryDisplayName,
            readTimeMinutes: readTimeMinutes(for: tip.content),
            title: tip.title,
            authorName: defaultAuthor,
            publishedDate: defaultPublishLabel,
            pullQuote: nil,
            paragraphs: paragraphs,
            relatedArticles: Array(related)
        )
    }

    // MARK: - Helpers

    private static let defaultAuthor = "BesideHer Editors"
    private static let defaultPublishLabel = "Pregnancy guide"

    private static func readTimeMinutes(for content: String) -> Int {
        let words = content.split { $0.isWhitespace }.count
        return max(1, Int(ceil(Double(words) / 180.0)))
    }

    /// Splits a tip's prose into 1–2 paragraphs on sentence boundaries.
    /// Tip content is dense and short — a single paragraph for very short
    /// content, or split near the midpoint for longer pieces.
    private static func paragraphs(from content: String) -> [String] {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let sentences = splitIntoSentences(trimmed)

        if sentences.count <= 2 { return [trimmed] }

        let mid = sentences.count / 2
        let first = sentences[..<mid].joined(separator: " ")
        let second = sentences[mid...].joined(separator: " ")
        return [first, second]
    }

    private static func splitIntoSentences(_ text: String) -> [String] {
        let terminators: Set<Character> = [".", "!", "?"]
        var sentences: [String] = []
        var current = ""

        for char in text {
            current.append(char)
            if terminators.contains(char) {
                let trimmed = current.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty { sentences.append(trimmed) }
                current = ""
            }
        }

        let tail = current.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tail.isEmpty { sentences.append(tail) }

        return sentences
    }
}

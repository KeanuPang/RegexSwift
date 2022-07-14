//
//  RegexSwift+CJK.swift
//
//
//  Created by Keanu Pang on 2022/7/13.
//

public enum PatternCJK {
    case chinese
    case japanese
    case korean
    case cjk

    public var regexPattern: StaticString {
        switch self {
        case .chinese:
            return "\\p{Han}|\\p{Bopomofo}"
        case .japanese:
            return "\\p{Katakana}|\\p{Hiragana}"
        case .korean:
            return "\\p{Hangul}"
        case .cjk:
            return "\\p{Han}|\\p{Bopomofo}|\\p{Katakana}|\\p{Hiragana}|\\p{Hangul}"
        }
    }
}

private enum BlockPunctuationsCJK: String, CaseIterable {
    case CJK_Symbols_And_Punctuation = "[\\u3000-\\u303F]"
    case Vertical_Forms = "[\\uFE10-\\uFE1F]"
    case CJK_Compatibility_Forms = "[\\uFE30-\\uFE4F]"
    case Small_Form_Variants = "[\\uFE50-\\uFE6F]"
    case Halfwidth_And_Fullwidth_Forms = "[\\uFF00-\\uFFEF]"
    case Ideographic_Description_Characters = "[\\u2FF0-\\u2FFF]"

    static var regexPattern: String {
        return BlockPunctuationsCJK.allCases.map { $0.rawValue }.joined(separator: "|")
    }
}

extension RegexSwift {
    public static func hasChineseCharacters(in string: String) -> Bool {
        return byPatternCJK(pattern: PatternCJK.chinese).matches(string)
    }

    public static func hasJapaneseCharacters(in string: String) -> Bool {
        return byPatternCJK(pattern: PatternCJK.japanese).matches(string)
    }

    public static func hasKoreanCharacters(in string: String) -> Bool {
        return byPatternCJK(pattern: PatternCJK.korean).matches(string)
    }

    public static func hasCJKCharacters(in string: String) -> Bool {
        return byPatternCJK(pattern: PatternCJK.cjk).matches(string)
    }

    public static func hasCJKPunctuations(in string: String) -> Bool {
        return byPunctuationsCJK().matches(string)
    }

    public static func byPatternCJK(pattern: PatternCJK) -> RegexSwift {
        return RegexSwift(pattern.regexPattern)
    }

    public static func byPunctuationsCJK() -> RegexSwift {
        do {
            return try RegexSwift(string: BlockPunctuationsCJK.regexPattern)
        } catch {
            return RegexSwift("")
        }
    }
}

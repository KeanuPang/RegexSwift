//
//  RegexSwift+CJK.swift
//
//
//  Created by Keanu Pang on 2022/7/13.
//

private enum PatternCJK {
    case chinese
    case japanese
    case korean
    case cjk

    var regexPattern: StaticString {
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
        return RegexSwift(PatternCJK.chinese.regexPattern).matches(string)
    }

    public static func hasJapaneseCharacters(in string: String) -> Bool {
        return RegexSwift(PatternCJK.japanese.regexPattern).matches(string)
    }

    public static func hasKoreanCharacters(in string: String) -> Bool {
        return RegexSwift(PatternCJK.korean.regexPattern).matches(string)
    }

    public static func hasCJKCharacters(in string: String) -> Bool {
        return RegexSwift(PatternCJK.cjk.regexPattern).matches(string)
    }

    public static func hasCJKPunctuations(in string: String) -> Bool {
        do {
            return try RegexSwift(string: BlockPunctuationsCJK.regexPattern).matches(string)
        } catch {
            return false
        }
    }
}

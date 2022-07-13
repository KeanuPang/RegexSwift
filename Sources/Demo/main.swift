//
//  main.swift
//
//
//  Created by Keanu Pang on 2022/7/6.
//

import RegexSwift

// MARK: Chinese characters

let stringChinese = "這是中文"
print("//= hasChineseCharacters: \(RegexSwift.hasChineseCharacters(in: stringChinese))")

let stringBopomofo = "ㄎㄫㄐㄑㄬㄉㄊㄋ"
print("//= hasChineseCharacters: \(RegexSwift.hasChineseCharacters(in: stringBopomofo))")

let stringChinesePunctuation = "＋"
print("//= hasCJKPunctuations: \(RegexSwift.hasCJKPunctuations(in: stringChinesePunctuation))")

// MARK: Japanese characters

let stringJapanese = "これは日本人です"
print("//= hasJapaneseCharacters: \(RegexSwift.hasJapaneseCharacters(in: stringJapanese))")

// MARK: Koren characters

let stringKorean = "이것은 한국어입니다"
print("//= hasKoreanCharacters: \(RegexSwift.hasKoreanCharacters(in: stringKorean))")

// MARK: CJK characters

let stringCJK = "這是中文,これは日本人です,이것은 한국어입니다"
print("//= hasCJKCharacters: \(RegexSwift.hasCJKCharacters(in: stringCJK))")

// MARK: Others

let string = "test text"
print("//= non CJK text: \(RegexSwift.hasChineseCharacters(in: string) == false)")

let stringPunctuation = ","
print("//= non CJK punctuation: \(RegexSwift.hasCJKPunctuations(in: stringPunctuation) == false)")

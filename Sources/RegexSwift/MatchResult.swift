// Source code from https://github.com/sharplet/Regex

import class Foundation.NSTextCheckingResult

/// A `MatchResult` encapsulates the result of a single match in a string,
/// providing access to the matched string, as well as any capture groups within
/// that string.
public struct MatchResult {
    // MARK: Accessing match results

    /// The entire matched string.
    ///
    /// Example:
    ///
    ///     let pattern = Regex("a*")
    ///
    ///     if let match = pattern.firstMatch(in: "aaa") {
    ///       match.matchedString // "aaa"
    ///     }
    ///
    ///     if let match = pattern.firstMatch(in: "bbb") {
    ///       match.matchedString // ""
    ///     }
    public var matchedSubstring: Substring {
        return _result.matchedSubstring
    }

    /// The range of the matched string.
    public var range: Range<String.Index> {
        return _result.range
    }

    /// The matching string for each capture group in the regular expression
    /// (if any).
    ///
    /// **Note:** Usually if the match was successful, the captures will by
    /// definition be non-nil. However if a given capture group is optional, the
    /// captured string may also be nil, depending on the particular string that
    /// is being matched against.
    ///
    /// Example:
    ///
    ///     let regex = Regex("(a)?(b)")
    ///
    ///     regex.firstMatch(in: "ab")?.captures // [Optional("a"), Optional("b")]
    ///     regex.firstMatch(in: "b")?.captures // [nil, Optional("b")]
    public var captures: [Substring] {
        return _result.captures
    }

    /// The ranges of each capture (if any).
    ///
    /// - seealso: The discussion and example for `MatchResult.captures`.
    public var captureRanges: [Range<String.Index>?] {
        return _result.captureRanges
    }

    // MARK: Internal initialisers

    internal var matchResult: NSTextCheckingResult {
        return _result.result
    }

    private let _result: _MatchResult

    internal init(_ string: String, _ result: NSTextCheckingResult) {
        self._result = _MatchResult(string, result)
    }
}

// Use of a private class allows for lazy vars without the need for `mutating`.
private final class _MatchResult {
    private let string: String
    fileprivate let result: NSTextCheckingResult

    fileprivate init(_ string: String, _ result: NSTextCheckingResult) {
        self.string = string
        self.result = result
    }

    lazy var range: Range<String.Index> = Range(self.result.range, in: string)!

    lazy var captures: [Substring] = self.captureRanges.map { range in
        range.map { self.string[$0] } ?? Substring()
    }

    lazy var captureRanges: [Range<String.Index>?] = self.result.ranges.dropFirst().map { Range($0, in: self.string) }

    lazy var matchedSubstring: Substring = {
        guard let range = Range(self.result.range, in: self.string) else { return "" }

        return self.string[range]
    }()
}

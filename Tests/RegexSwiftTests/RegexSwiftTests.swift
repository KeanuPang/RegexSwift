import RegexSwift
import XCTest

final class RegexTests: XCTestCase {
    func testRegexMatchesWithNoCaptureGroups() {
        let regex = RegexSwift("now you're matching with regex")
        XCTAssertMatches(regex, "now you're matching with regex")
    }

    func testRegexMatchesSingleCaptureGroup() {
        let regex = RegexSwift("foo (bar|baz)")
        XCTAssertCaptures(regex, captures: "bar", from: "foo bar")
    }

    func testRegexMatchesMultipleCaptureGroups() {
        let regex = RegexSwift("foo (bar|baz) (123|456)")
        XCTAssertCaptures(regex, captures: "baz", "456", from: "foo baz 456")
    }

    func testRegexDoesNotIncludeEntireMatchInCaptureList() {
        let regex = RegexSwift("foo (bar|baz)")
        XCTAssertDoesNotCapture(regex, captures: "foo bar", from: "foo bar")
    }

    func testRegexProvidesAccessToTheEntireMatchedString() {
        let regex = RegexSwift("foo (bar|baz)")
        XCTAssertEqual(regex.firstMatch(in: "foo bar")?.matchedSubstring, "foo bar")
    }

    func testRegexCanMatchMultipleTimesInTheSameString() {
        let regex = RegexSwift("(foo)")
        let matches = regex
            .allMatches(in: "foo foo foo")
            .flatMap { $0.captures }
            .compactMap { $0 }

        XCTAssertEqual(matches, ["foo", "foo", "foo"])
    }

    func testRegexSupportsMatchOperator() {
        let matched: Bool

        switch "eat some food" {
        case RegexSwift("foo"):
            matched = true
        default:
            matched = false
        }

        XCTAssertTrue(matched)
    }

    func testRegexSupportsMatchOperatorInReverse() {
        let matched: Bool

        switch RegexSwift("foo") {
        case "fool me twice":
            matched = true
        default:
            matched = false
        }

        XCTAssertTrue(matched)
    }

    func testRegexProvidesAccessToTheMatchedRange() {
        let foobar = "foobar"
        let match = RegexSwift("f(oo)").firstMatch(in: foobar)
        XCTAssertNotNil(match)
        XCTAssertEqual(foobar[match!.range], "foo")
    }

    func testRegexProvidesAccessToCaptureRanges() {
        let foobar = "foobar"
        let match = RegexSwift("f(oo)b(ar)").firstMatch(in: foobar)!
        let firstCaptureRange = match.captureRanges[0]!
        let secondCaptureRange = match.captureRanges[1]!
        XCTAssertEqual(foobar[firstCaptureRange], "oo")
        XCTAssertEqual(foobar[secondCaptureRange], "ar")
    }

    func testRegexOptionatCaptureGroupsMaintainCapturePositionRegardlessOfOptionality() {
        let regex = RegexSwift("(a)?(b)")
        XCTAssertEqual(regex.firstMatch(in: "ab")?.captures[1], "b")
        XCTAssertEqual(regex.firstMatch(in: "b")?.captures[1], "b")
    }

    func testRegexOptionatCaptureGroupsReturnNilForUnmatchedCaptures() {
        let regex = RegexSwift("(a)?(b)")
        XCTAssertNil(regex.firstMatch(in: "b")?.captures[0])
    }

    func testRegexCaptureRangesCorrectlyConvertFromUnderlyingIndexType() {
        // U+0061 LATIN SMALL LETTER A
        // U+0065 LATIN SMALL LETTER E
        // U+0301 COMBINING ACUTE ACCENT
        // U+221E INFINITY
        // U+1D11E MUSICAL SYMBOL G CLEF
        let string = "\u{61}\u{65}\u{301}\u{221E}\u{1D11E}"
        let infinity = RegexSwift("(\u{221E})").firstMatch(in: string)!.captures[0]
        let rangeOfInfinity = string.range(of: infinity)!
        let location = string.distance(from: string.startIndex, to: rangeOfInfinity.lowerBound)
        let length = string.distance(from: rangeOfInfinity.lowerBound, to: rangeOfInfinity.upperBound)
        XCTAssertEqual(location, 2)
        XCTAssertEqual(length, 1)
    }

    func testValidateReadmeExampleForCaptureRanges() {
        let lyrics = """
        So it's gonna be forever
        Or it's gonna go down in flames
        """

        let possibleEndings = RegexSwift("it's gonna (.+)")
            .allMatches(in: lyrics)
            .compactMap { $0.captureRanges[0] }
            .map { lyrics[$0] }

        XCTAssertEqual(possibleEndings, ["be forever", "go down in flames"])
    }

    func testRegexWhenMatchingAtLineAnchorsCanAnchorMatchesToTheStartOfEachLine() {
        let regex = RegexSwift("(?m)^foo")
        let multilineString = "foo\nbar\nfoo\nbaz"
        XCTAssertEqual(regex.allMatches(in: multilineString).count, 2)
    }

    func testRegexWhenMatchingAtLineAnchorsValidatesReadmeExampleIsCorrect() {
        let totallyUniqueExamples = RegexSwift(
            "^(hello|foo).*$",
            options: [.caseInsensitive, .anchorsMatchLines]
        )
        let multilineText = "hello world\ngoodbye world\nFOOBAR\n"
        let matchingLines = totallyUniqueExamples.allMatches(in: multilineText).map { $0.matchedSubstring }
        XCTAssertEqual(matchingLines, ["hello world", "FOOBAR"])
    }

    func testRegexLastMatchIsAvailableInPatternMatchingContext() {
        switch "hello" {
        case RegexSwift("l+"):
            XCTAssertEqual(RegexSwift.lastMatch?.matchedSubstring, "ll")
        default:
            XCTFail("expected regex to match")
        }
    }

    func testRegexLastMatchResetsLastMatchToNilWhenMatchFails() {
        _ = "foo" ~= RegexSwift("foo")
        XCTAssertNotNil(RegexSwift.lastMatch)
        _ = "foo" ~= RegexSwift("bar")
        XCTAssertNil(RegexSwift.lastMatch)
    }

    func testRegexMatchCRLF() {
        let source = "\r\n"
        let regex = RegexSwift("\r\n")
        let match = regex.firstMatch(in: source)!
        let matchedString = String(match.matchedSubstring)

        XCTAssertEqual(matchedString, source)
    }
}

// swiftlint:disable line_length

import RegexSwift
import XCTest

func XCTAssertMatches(_ regularExpression: RegexSwift, _ stringMatch: String, _ file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(regularExpression.matches(stringMatch), "expected <\(regularExpression)> to match <\(stringMatch)>", file: file, line: line)
}

func XCTAssertDoesNotMatch(_ regularExpression: RegexSwift, _ stringMatch: String, _ file: StaticString = #file, line: UInt = #line) {
    XCTAssertFalse(regularExpression.matches(stringMatch), "expected <\(regularExpression)> not to match <\(stringMatch)>", file: file, line: line)
}

func XCTAssertCaptures(_ regularExpression: RegexSwift, captures: Substring..., from string: String, _ file: StaticString = #file, line: UInt = #line) {
    for expected in captures {
        let match = regularExpression.firstMatch(in: string)
        XCTAssertNotNil(match, file: file, line: line)
        XCTAssertTrue(match!.captures.contains(where: { $0 == expected }), "expected <\(regularExpression)> to capture <\(captures)> from <\(string)> ", file: file, line: line)
    }
}

func XCTAssertDoesNotCapture(_ regularExpression: RegexSwift, captures: Substring..., from string: String, _ file: StaticString = #file, line: UInt = #line) {
    for expected in captures {
        let match = regularExpression.firstMatch(in: string)
        XCTAssertNotNil(match, file: file, line: line)
        XCTAssertFalse(match!.captures.contains(where: { $0 == expected }), "expected <\(regularExpression)> to not capture <\(captures)> from <\(string)> ", file: file, line: line)
    }
}

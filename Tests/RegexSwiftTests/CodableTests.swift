import Foundation
import RegexSwift
import XCTest

struct Form: Codable, Equatable {
    struct Validation: Codable, Equatable {
        var name: String
        var pattern: RegexSwift
    }

    var validations: [Validation]
}

final class CodableTests: XCTestCase {
    let json = """
    {
      "validations" : [
        {
          "name" : "greeting",
          "pattern" : "^(\\\\w+) world!$"
        }
      ]
    }
    """

    let form = Form(
        validations: [
            Form.Validation(name: "greeting", pattern: RegexSwift("^(\\w+) world!$")),
        ]
    )

    func testCanBeDecodedFromJSON() {
        let data = json.data(using: .utf8)!
        XCTAssertEqual(try JSONDecoder().decode(Form.self, from: data), form)
    }

    func testCanBeEncodedToJSON() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(form)
        let object = try cast(JSONSerialization.jsonObject(with: data), to: NSDictionary.self)
        let dictionary = try cast(object, to: NSDictionary.self)

        XCTAssertEqual(dictionary, [
            "validations": [
                ["name": "greeting", "pattern": "^(\\w+) world!$"],
            ],
        ])
    }

    func testIsIdenticalAfterEncodingAndDecoding() throws {
        struct Payload: Codable { var regex: RegexSwift }
        let original = Payload(regex: RegexSwift("^(\\w+) world!$"))
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Payload.self, from: encoded)

        XCTAssertEqual(original.regex, decoded.regex)
    }
}

struct DynamicCastError: Error {
    var value: Any
    var expectedType: Any.Type
    var file: String
    var line: Int
}

func cast<T>(_ value: Any, to _: T.Type, file: String = #file, line: Int = #line) throws -> T {
    if let value = value as? T {
        return value
    } else {
        throw DynamicCastError(value: value, expectedType: T.self, file: file, line: line)
    }
}

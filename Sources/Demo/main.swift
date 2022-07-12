//
//  main.swift
//
//
//  Created by Keanu Pang on 2022/7/6.
//

import RegexSwift

let greeting = RegexSwift("hello (world|universe|swift)")

if let subject = greeting.firstMatch(in: "hello swift")?.captures[0] {
    print("ohai \(subject)")
}

let result = "hello world".replacingFirst(matching: "h(ello) (\\w+)", with: "H$1, $2!")
print("//= result: \(result)")

switch "goodbye world" {
case RegexSwift("hello (\\w+)"):
    if let friend = RegexSwift.lastMatch?.captures[0] {
        print("lovely to meet you, \(friend)!")
    }
case RegexSwift("goodbye (\\w+)"):
    if let traitor = RegexSwift.lastMatch?.captures[0] {
        print("so sorry to see you go, \(traitor)!")
    }
default:
    break
}

let totallyUniqueExamples = RegexSwift("^(hello|foo).*$", options: [.caseInsensitive, .anchorsMatchLines])
let multilineText = "hello world\ngoodbye world\nFOOBAR\n"
let matchingLines = totallyUniqueExamples.allMatches(in: multilineText).map { $0.matchedSubstring }
// ["hello world", "FOOBAR"]

print(matchingLines)

//
//  Message.swift
//  Book_Sources
//
//  Created by Satsuki Hashiba on 2019/03/24.
//

import PlaygroundSupport

public struct Message {
    let from: String
    let body: String

    public init(from: String, body: String) {
        self.from = from
        self.body = body
    }

    public func toPlaygroundValue() -> PlaygroundValue {
        let data = PlaygroundValue.dictionary(
            [
                "from": PlaygroundValue.string(from),
                "body": PlaygroundValue.string(body)
            ]
        )
        return data
    }

    static func convert(from playgroundValue: PlaygroundValue) -> Message? {
        guard case let .dictionary(dictionary) = playgroundValue else { return nil }

        if case let .string(from)? = dictionary["from"],
            case let .string(body)? = dictionary["body"] {
            return Message.init(from: from, body: body)
        }
        return nil
    }
}

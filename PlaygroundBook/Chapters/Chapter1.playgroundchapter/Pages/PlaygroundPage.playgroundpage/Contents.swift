//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func setTitle(_ title: String) {
    let data = PlaygroundValue.dictionary([
        "title" : PlaygroundValue.string(title)
    ])
    proxy?.send(data)
}

func setMessages(_ messages: [Message]) {
    let array = PlaygroundValue.array(messages.map { $0.toPlaygroundValue() })
    proxy?.send(array)
}

proxy?.send(PlaygroundValue.string("reset"))

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, Message, (from:body:), from:body:, (from:body:, from:body:))
//#-code-completion(identifier, show, (, ))
//#-end-hidden-code

/*:
 It's time to give your program for a loved one! 💘
 You can create an interactive message board with this playground.
 This is perfect for a farewell gift or a birthday present! 😉
 */

let title = /*#-editable-code*/"Dear Tim"/*#-end-editable-code*/
setTitle(title)

let messages = [
    //#-editable-code
    //This is an example - write your message!
    Message(from: "Alice", body: "Thank you!"),
    Message(from: "Bob", body: "Good job."),
    Message(from: "Carol", body: "All the best!"),
    Message(from: "Dave", body: "Keep in touch :)"),
    Message(from: "Eve", body: "Good Luck."),
    Message(from: "Frank", body: "Do well!"),
    Message(from: "Grace", body: "I miss you."),
    Message(from: "Hannah", body: "Farewell!"),
    Message(from: "Ivan", body: "See you soon!"),
    Message(from: "Judy", body: "Nice work!"),
    Message(from: "Kylie", body: "Take care :)"),
    Message(from: "Lisa", body: "Stay in touch!"),
    Message(from: "Mike", body: "I will never forget you."),
    Message(from: "Nicola", body: "You'll never walk alone!"),
    Message(from: "Olivia", body: "I love you!"),
    //#-end-editable-code
]
setMessages(messages)


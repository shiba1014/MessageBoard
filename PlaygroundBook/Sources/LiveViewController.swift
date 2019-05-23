//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import PlaygroundSupport
import ARKit
import SceneKit

@objc(Book_Sources_LiveViewController)
public class LiveViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    private let depth = CGFloat(Bubble.depth)
    private var arscnView = ARSCNView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        enableCameraVision()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: arscnView) {
            guard let result = arscnView.hitTest(location, options: nil).first,
                let bubble = result.node.parent?.parent as? Bubble else { return }
            bubble.tapped()
        }
    }
}

extension LiveViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        switch message {
        case let .dictionary(dictionary):
            if case let .string(title)? = dictionary["title"] {
                setTextNode(title)
            }

        case let .array(array):
            let messages = array.compactMap { Message.convert(from: $0) }
            setMessageNodes(messages: messages)

        case let .string(string):
            if string == "reset" {
                reset()
            }

        default:
            break
        }
    }
}

private extension LiveViewController {
    func enableCameraVision() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self.setupScene()
                }
            }
        }
    }

    func setupScene() {
        guard ARWorldTrackingConfiguration.isSupported else { return }

        arscnView = ARSCNView(frame: view.frame)
        arscnView.session = ARSession()
        view.addSubview(arscnView)

        arscnView.translatesAutoresizingMaskIntoConstraints = false
        // Constraints for new arscnView
        NSLayoutConstraint.activate([
            arscnView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            arscnView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            arscnView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            arscnView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            ])

        arscnView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])

        // Automatic VoiceOver to notify user screen is now on camera view
        let axScreenDescription = "The screen is now displaying a direct camera feed."
        UIAccessibility.post(notification: .screenChanged, argument: axScreenDescription)
    }

    func reset() {
        arscnView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
    }

    func setMessageNodes(messages: [Message]) {
        messages.enumerated().forEach { i, message in
            let bubble = Bubble(index: i, message: message)
            arscnView.scene.rootNode.addChildNode(bubble)
        }
    }

    func setTextNode(_ text: String) {
        let textGeometry = SCNText(string: text, extrusionDepth: 0.05)
        textGeometry.font = .systemFont(ofSize: 1)
        let textNode = SCNNode(geometry: textGeometry)

        let (min, max) = (textNode.boundingBox)
        let width = CGFloat(max.x - min.x)
        let height = CGFloat(max.y - min.y)
        textNode.position = SCNVector3(-(width / 2), -(height / 2) - 0.9 , depth)

        arscnView.scene.rootNode.addChildNode(textNode)
    }
}

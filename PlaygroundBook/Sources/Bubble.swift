//
//  Bubble.swift
//  Book_Sources
//
//  Created by Satsuki Hashiba on 2019/03/24.
//

import SceneKit

class Bubble: SCNNode {
    static let flyingDuration: TimeInterval = 2
    static let baseLimitCount: Int = 5
    static let depth: Double = -10
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))

    private let message: Message

    private var nameNode = SCNNode()
    private var bodyNode = SCNNode()
    private var isMessageShow:Bool = false {
        didSet {
            nameNode.isHidden = isMessageShow
            bodyNode.isHidden = !isMessageShow
        }
    }

    init(index: Int, message: Message) {
        self.message = message
        super.init()
        createBubble(index: index)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapped() {
        isMessageShow.toggle()
    }
}

private extension Bubble {
    func createBubble(index: Int) {
        let i = index + 1

        // Setup bubble
        let bubble = SCNSphere(radius: 2)
        let material = SCNMaterial()
        material.diffuse.contents = Color.get(index: index)
        material.transparency = 0.5
        material.writesToDepthBuffer = false
        bubble.firstMaterial = material

        let bubbleNode = SCNNode(geometry: bubble)
        bubbleNode.position = .init(0, 0.1, 0)
        addChildNode(bubbleNode)

        let animationNode = SCNNode()
        animationNode.addChildNode(bubbleNode)
        addChildNode(animationNode)

        // Setup text
        let name = SCNText(string: message.from, extrusionDepth: 0.05)
        name.font = .systemFont(ofSize: 1)
        nameNode = SCNNode(geometry: name)
        let (nameMin, nameMax) = (nameNode.boundingBox)
        let nw = CGFloat(nameMax.x - nameMin.x)
        let nh = CGFloat(nameMax.y - nameMin.y)
        nameNode.position = SCNVector3(-(nw / 2), -(nh / 2) - 0.9 , 0)
        addChildNode(nameNode)

        let body = SCNText(string: message.body, extrusionDepth: 0.05)
        body.font = .systemFont(ofSize: 0.5)
        bodyNode = SCNNode(geometry: body)
        let (bodyMin, bodyMax) = (bodyNode.boundingBox)
        let bw = CGFloat(bodyMax.x - bodyMin.x)
        let bh = CGFloat(bodyMax.y - bodyMin.y)
        bodyNode.position = SCNVector3(-(bw / 2), -(bh / 2) - 0.9 , 0)
        bodyNode.isHidden = true
        addChildNode(bodyNode)

        // Setup position
        let section = calcSection(index: i)
        let orbitRadius = Double(2.7 * bubble.radius * CGFloat(section))
        let limitCount = Bubble.baseLimitCount * section
        let rad = 2 * Double.pi / Double(limitCount) * Double(i)
        let x = orbitRadius * cos(rad)
        let y = orbitRadius * sin(rad)

        position = SCNVector3(0, 0, -10)

        let point = SCNVector3(x, y, Bubble.depth + Double(section - 1))
        let fly = SCNAction.move(to: point, duration: Bubble.flyingDuration)
        fly.timingMode = .easeOut
        runAction(fly) {
            let duration: TimeInterval = Double.random(in: 1...1.5)
            let rotate = SCNAction.rotateBy(x: 0, y: 0, z: bubble.radius * 1.5, duration: duration)
            let roop = SCNAction.repeatForever(rotate)
            animationNode.runAction(roop)
        }

        let billboardConstraint = SCNBillboardConstraint()
        constraints = [billboardConstraint]
    }

    func calcSection(index: Int) -> Int {
        let section = solveQuadraticFormula(a: Bubble.baseLimitCount, b: Bubble.baseLimitCount, c: index * -2)
        return Int(ceil(section))
    }

    func solveQuadraticFormula(a: Int, b: Int, c: Int) -> Double {
        let x = Double(b*b - 4*a*c)
        let numerator = Double(-b) + sqrt(x)
        let denominator = Double(2 * a)
        return numerator / denominator
    }
}

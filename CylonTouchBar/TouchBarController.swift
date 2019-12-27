//
//  ToucharBarController.swift
//  CylonTouchBar
//
//  Created by Ryan M. Adzima on 12/12/16.
//  Copyright © 2016 Ryan M. Adzima. All rights reserved.
//

import Cocoa

fileprivate extension NSTouchBar.CustomizationIdentifier {
    
    static let cylonTouchBar = NSTouchBar.CustomizationIdentifier("io.ronintech.CylonTouchBar")
}

fileprivate extension NSTouchBarItem.Identifier {
    static let cylon = NSTouchBarItem.Identifier("cylon")
}

@available(OSX 10.12.1, *)
class TouchBarController: NSWindowController, NSTouchBarDelegate, CAAnimationDelegate {
    
    let cylonView = NSView()
    let sound = NSSound(named: NSSound.Name(rawValue: "BSG_Cylon_Slow"))
    let loops: Bool = true

    override func windowDidLoad() {
        super.windowDidLoad()
        handleMusic()
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = NSTouchBar.CustomizationIdentifier.cylonTouchBar
        touchBar.defaultItemIdentifiers = [.cylon]
        touchBar.customizationAllowedItemIdentifiers = [.cylon]
        
        return touchBar
        
    }
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        let wholeTouchBar = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case NSTouchBarItem.Identifier.cylon:
            // Need this to be 0:07.450 seconds long
            self.cylonView.wantsLayer = true
            let theLEDs = CAShapeLayer()
            let time: Double = 7.45
            let iters = 20.0
            let ledDuration: Double = time / 8
            let delay = (ledDuration / iters) / 2
            let ledValues = [1, 0.75, 0.5, 0.25, 0.125, 0]
            let ledKeyTimes = [0, ledDuration / 8, ledDuration / 7, ledDuration / 6, ledDuration / 5, ledDuration / 4, ledDuration / 1.5]//, ledDuration / 1.75, ledDuration / 1.5, ledDuration / 1.25, ledDuration ]
            let space: Double = 30
            var between: Double = space
            for item in 0...Int(iters - 1) {
                let aLEDLeft = createLED(x: between+(2.5*Double(item)), y: 2.5, width: 27.5, height: 27.5, xRadius: 15.0, yRadius: 15.0)
                let aLEDRight = createLED(x: between+(2.5*Double(item)), y: 2.5, width: 27.5, height: 27.5, xRadius: 15.0, yRadius: 15.0)
                theLEDs.addSublayer(aLEDLeft)
                theLEDs.addSublayer(aLEDRight)
                
                let theLEDAnimLeft = createAnim(
                    duration: ledDuration,
                    delay: CACurrentMediaTime() + delay * Double(item),
                    values: ledValues as [NSNumber],
                    keyTimes: ledKeyTimes as [NSNumber],
                    reverses: false)

                aLEDLeft.add(theLEDAnimLeft, forKey: "opacity")

                let theLEDAnimRight = createAnim(
                    duration: ledDuration,
                    delay: (ledDuration / 2)+(CACurrentMediaTime() + delay * Double(Int(iters)-item)),
                    values: ledValues as [NSNumber],
                    keyTimes: ledKeyTimes as [NSNumber],
                    reverses: false)
                
                aLEDRight.add(theLEDAnimRight, forKey: "opacity")
                
                between += space
            }
            
            cylonView.layer?.addSublayer(theLEDs)
            wholeTouchBar.view = cylonView
            
            return wholeTouchBar
        default:
            return nil
        }
    }
    
    func createLED(x: Double, y: Double, width: Double, height: Double, xRadius: CGFloat, yRadius: CGFloat) -> CAShapeLayer {
        let aLED = CAShapeLayer()
        // LED shape
        let aLEDRect = CGRect(x: x, y: y, width: width, height: height)
        aLED.path = NSBezierPath(roundedRect: aLEDRect, xRadius: xRadius, yRadius: yRadius).cgPath
        aLED.opacity = 0
        aLED.fillColor = NSColor.red.cgColor
        // LED color glow
        aLED.shadowColor = NSColor.red.cgColor
        aLED.shadowOffset = CGSize.zero
        aLED.shadowRadius = 6.0
        aLED.shadowOpacity = 1.0
        return aLED
    }
    
    func createAnim(duration: CFTimeInterval, delay: CFTimeInterval, values: [NSNumber], keyTimes: [NSNumber], reverses: Bool) -> CAKeyframeAnimation {
        let theLEDAnim = CAKeyframeAnimation(keyPath: "opacity")
//        theLEDAnim.calculationMode = kCAAnimationPaced
        theLEDAnim.duration = duration
        theLEDAnim.beginTime = delay
        theLEDAnim.values = values
        theLEDAnim.keyTimes = keyTimes
        theLEDAnim.autoreverses = reverses
        theLEDAnim.repeatCount = .infinity
        theLEDAnim.delegate = self
        return theLEDAnim
    }
    func handleMusic() {
        self.sound?.loops = self.loops
        self.sound?.play()
    }
}

// Apple puts that code in the docs instead of just adding a CGPath accessor to NSBezierPath
// From: http://stackoverflow.com/questions/1815568/how-can-i-convert-nsbezierpath-to-cgpath/39385101#39385101
extension NSBezierPath {
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }
        return path
    }
}

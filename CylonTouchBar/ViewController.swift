//
//  ViewController.swift
//  CylonTouchBar
//
//  Created by Ryan M. Adzima on 12/12/16.
//  Copyright © 2016 Ryan M. Adzima. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var cylon: NSImageView!
//    @IBOutlet weak var loopEffect: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        
        cylon.image = NSImage(named: "cylon.gif")
        cylon.frame = CGRect(x: 0, y: 0, width: 265, height: 265)
        cylon.animates = true
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let bgColor: CGColor = .black
            self.view.layer?.backgroundColor = bgColor
//            let loopEffectLabel = NSAttributedString(string: "Continuous", attributes: [NSForegroundColorAttributeName: NSColor.white])
//            self.loopEffect.attributedTitle = loopEffectLabel
        }
    }

}


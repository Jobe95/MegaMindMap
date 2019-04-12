//
//  BubbleView.swift
//  MegaMindMap
//
//  Created by Jonatan Bengtsson on 2019-04-11.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

protocol BubbleViewDelegate {
    func didSelect(_ bubble: BubbleView)
    func didEdit(_ bubble: BubbleView)
    func didPan(_ bubble: BubbleView)
}

class BubbleView: UIView {
    
    var delegate: BubbleViewDelegate?
    var color: UIColor?
    var uuid = UUID().uuidString
    var lines = [LineView]()
    private var label = UILabel()
    
    var text: String {
        get {
            return label.text ?? "Text"
        }
        set (str){
            label.text = str
            updateFrame()
        }
    }
    
    //MARK: - Selected property
    
    var selected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let minSize: CGFloat = 80
    let maxWidth: CGFloat = 240
    let padding: CGFloat = 8
    //MARK: - Init
    
    init(_ atPoint: CGPoint) {
        
        let frame = CGRect(x: atPoint.x-minSize/2, y: atPoint.y-minSize/2, width: minSize, height: minSize)
        super.init(frame: frame)
        
        color = UIColor.random()
        backgroundColor = UIColor.clear
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanInBubble(_:)))
        addGestureRecognizer(pan)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapInBubble(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapInBubble(_:)))
        tap.require(toFail: doubleTap)
        addGestureRecognizer(tap)
        
        
        // SKapa en label för din bubbla
        label.frame = bounds
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "Text"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addSubview(label)
    }
    
    func data() -> [String:String] {
        var data = [String:String]()
        
        data["uuid"] = uuid
        data["center"] = NSCoder.string(for: center)
        data["text"] = text
        
        return data
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Gestures
    
    @objc func didPanInBubble(_ gesture: UIPanGestureRecognizer) {
        print("Did pan")
        if gesture.state == .changed {
            self.center = gesture.location(in: superview)
            //Uppdatera alla linjer
            for line in lines {
                line.update()
                
            }
        } else if gesture.state == .began {
            superview?.bringSubviewToFront(self)
        }
        
        delegate?.didPan(self)
    }
    
    @objc func didTapInBubble(_ gesture: UITapGestureRecognizer) {
        print("Did tap in bubble")
        guard let bubble = gesture.view as? BubbleView else {
            return
        }
        
        if delegate != nil {
            delegate?.didSelect(bubble)
        }
    }
    
    @objc func didDoubleTapInBubble(_ gesture: UITapGestureRecognizer) {
        print("Did tap in bubble")
        guard let bubble = gesture.view as? BubbleView else {
            return
        }
        
        if delegate != nil {
            delegate?.didEdit(bubble)
        }
    }
    
    
    func delete() {
        for line in lines {
            line.removeFromSuperview()
        }
        removeFromSuperview()
    }
    
    //MARK: - Draw
    
    func updateFrame() {
        // Beräkna frame för label och vy
        
        let labelSize = label.sizeThatFits(
            CGSize(width: maxWidth-padding*2, height: minSize-padding*2))
        let bubbleWidth = max(minSize, labelSize.width+padding*2)
        label.frame = CGRect(x: padding,
                             y: padding,
                             width: bubbleWidth-padding*2,
                             height: minSize-padding*2)
        frame = CGRect(x: center.x-bubbleWidth/2,
                       y: center.y-minSize/2,
                       width: bubbleWidth,
                       height: minSize)
        
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .topRight], cornerRadii: CGSize(width: bounds.size.width/2, height: bounds.size.height/2))
        // VILLKOR ? SANT : FALSKT
        selected ? UIColor.yellow.setFill() : color?.setFill()
        path.fill()
        
    }
    

}


extension UIColor {
    
    static func random() -> UIColor {
        let randomRed = CGFloat(arc4random_uniform(256))/255.0
        let randomGreen = CGFloat(arc4random_uniform(256))/255.0
        let randomBlue = CGFloat(arc4random_uniform(256))/255.0
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1)
    }
}

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
}

class BubbleView: UIView {
    
    var lines = [LineView]()
    
    var delegate: BubbleViewDelegate?
    
    init(_ atPoint: CGPoint) {
        let size:CGFloat = 80
        let frame = CGRect(x: atPoint.x-size/2, y: atPoint.y-size/2, width: size, height: size)
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        layer.cornerRadius = size/2
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanInBubble(_:)))
        addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapInBubble(_:)))
        addGestureRecognizer(tap)
        // SKapa en label för din bubbla
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "Text"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addSubview(label)
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
        }
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

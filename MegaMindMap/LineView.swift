//
//  LineView.swift
//  MegaMindMap
//
//  Created by Jonatan Bengtsson on 2019-04-11.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    var fromView: BubbleView?
    var toView:BubbleView?
    
    init(from: BubbleView, to: BubbleView) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        fromView = from
        toView = to
        update()
    }
    
    
    func data() -> [String:String] {
        var data = [String:String]()
        data["fromUuid"] = fromView?.uuid
        data["toUuid"] = toView?.uuid
        
        return data
    }
    
    
    func update() {
        //TODO: Beräkna ny frame och påkalla ny utritning
        if fromView != nil && toView != nil {
            frame = fromView!.frame.union(toView!.frame)
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath()
        let origin = fromView!.center - frame.origin
        let destination = toView!.center - frame.origin
        let controlVector = CGPoint(x: (destination.x - origin.x) * 0.5, y: 0)
        path.move(to: origin) // Förflytta sig till startpunk
//        path.addLine(to: destination) // Skapa linje till slutpunkt
        path.addCurve(to: destination,
                      controlPoint1: origin + controlVector,
                      controlPoint2: destination - controlVector)
        path.lineWidth = 2.0
        fromView!.color?.setStroke()
        path.stroke()
    }

}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

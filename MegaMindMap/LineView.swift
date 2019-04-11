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
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        fromView = from
        toView = to
        update()
    }
    
    
    func update() {
        //TODO: Beräkna ny frame och påkalla ny utritning
        if fromView != nil && toView != nil {
            self.frame = fromView!.frame.union(toView!.frame)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

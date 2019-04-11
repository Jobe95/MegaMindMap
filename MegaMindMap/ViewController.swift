//
//  ViewController.swift
//  MegaMindMap
//
//  Created by Jonatan Bengtsson on 2019-04-11.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BubbleViewDelegate {

    var selectedBubble: BubbleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        //TODO: Hitta CGPoint och lägg till bubbla
        print("Did tap")
        if selectedBubble != nil {
            selectedBubble?.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
            selectedBubble = nil
        } else {
            let tapPoints = gesture.location(in: view)
            let bubble = BubbleView(tapPoints)
            bubble.delegate = self
            view.addSubview(bubble)
        }
    }
    
    //MARK: - BubbleViewDelegate
    
    func didSelect(_ bubble: BubbleView) {
        if selectedBubble != nil {
            if bubble == selectedBubble {
                // Delete bubble
                bubble.removeFromSuperview()
                
            } else {
                //TODO: Connect bubbles!
                let line = LineView(from: selectedBubble!, to: bubble)
                view.insertSubview(line, at: 0)
                //Lägg till i array för bubblor
                selectedBubble?.lines.append(line)
                bubble.lines.append(line)
            }
            //TODO: Deselect selectedBubble
            selectedBubble?.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
            selectedBubble = nil
        } else {
            selectedBubble = bubble
            selectedBubble?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
    }
    
}


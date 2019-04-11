//
//  ViewController.swift
//  MegaMindMap
//
//  Created by Jonatan Bengtsson on 2019-04-11.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BubbleViewDelegate, UIScrollViewDelegate {

    var selectedBubble: BubbleView?
    var superScrollView: UIScrollView?
    var sueperContentView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Konfigurera scrollvy
        superScrollView = UIScrollView(frame: view.bounds)
        superScrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        superScrollView?.delegate = self
        let contentSize: CGFloat = 2000
        superScrollView?.contentSize = CGSize(width: contentSize, height: contentSize)
        superScrollView?.contentOffset = CGPoint(x: contentSize/2 - view.frame.size.width/2, y: contentSize/2 - view.frame.size.height/2)
        superScrollView?.minimumZoomScale = 0.5
        superScrollView?.maximumZoomScale = 2.0
        
        // KOnfigurera content view
        sueperContentView = UIView(frame: CGRect(x: 0, y: 0, width: contentSize, height: contentSize))
        superScrollView?.addSubview(sueperContentView!)
        
        // Lägga till vår scrollvy i vår container
        view.addSubview(superScrollView!)
        
        // Lägga till en tap gesture (för att skapa nya bubblor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sueperContentView!.addGestureRecognizer(tap)
        
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        //TODO: Hitta CGPoint och lägg till bubbla
        print("Did tap")
        if selectedBubble != nil {
            selectedBubble?.deselect()
            selectedBubble = nil
        } else {
            let tapPoints = gesture.location(in: sueperContentView!)
            let bubble = BubbleView(tapPoints)
            bubble.delegate = self
            sueperContentView!.addSubview(bubble)
        }
    }
    
    //MARK: - BubbleViewDelegate
    
    func didEdit(_ bubble: BubbleView) {
        //TODO: - Visa popup med textfält
        let textInput = UIAlertController(title: "Edit bubble text", message: "Enter the text you want in the bubble", preferredStyle: .alert)
        textInput.addTextField { (textField) in
            textField.text = bubble.label.text
        }
        textInput.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let textField = textInput.textFields![0] as UITextField
            bubble.label.text = textField.text
        }))
        
        present(textInput, animated: true, completion: nil)
    }
    
    func didSelect(_ bubble: BubbleView) {
        if selectedBubble != nil {
            if bubble == selectedBubble {
                // Delete bubble
                bubble.delete()
                
            } else {
                //TODO: Connect bubbles!
                let line = LineView(from: selectedBubble!, to: bubble)
                sueperContentView!.insertSubview(line, at: 0)
                //Lägg till i array för bubblor
                selectedBubble?.lines.append(line)
                bubble.lines.append(line)
            }
            //TODO: Deselect selectedBubble
            selectedBubble?.deselect()
            selectedBubble = nil
        } else {
            selectedBubble = bubble
            selectedBubble?.select()
        }
    }
    // MARK: - UIScrollViewDelegate zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return sueperContentView
    }
}

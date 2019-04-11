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
            selectedBubble?.deselect()
            selectedBubble = nil
        } else {
            let tapPoints = gesture.location(in: view)
            let bubble = BubbleView(tapPoints)
            bubble.delegate = self
            view.addSubview(bubble)
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
                view.insertSubview(line, at: 0)
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
    
}

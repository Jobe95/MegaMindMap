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
    var superContenView: UIView?
    
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
        superContenView = UIView(frame: CGRect(x: 0, y: 0, width: contentSize, height: contentSize))
        superScrollView?.addSubview(superContenView!)
        
        // Lägga till vår scrollvy i vår container
        view.addSubview(superScrollView!)
        
        // Lägga till en tap gesture (för att skapa nya bubblor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        superContenView!.addGestureRecognizer(tap)
        
        // Ladda bubblor och linjer!
        load()
        
    }
    
    func load() {
        if let bubbleArray = UserDefaults.standard.array(forKey: "bubbles") as? [[String:String]] {
            for data in bubbleArray {
                let center: CGPoint = NSCoder.cgPoint(for: data["center"]!)
                let bubbleView = BubbleView(center)
                bubbleView.uuid = data["uuid"]!
                superContenView?.addSubview(bubbleView)
                bubbleView.text = data["text"]!
                bubbleView.delegate = self
                
            }
        }
        if let lineArray = UserDefaults.standard.array(forKey: "lines") as? [[String:String]] {
            for data in lineArray {
                let fromUuid = data["fromUuid"]
                
                let toUuid = data["toUuid"]
                if let fromView = bubbleViewForUuid(uuid: fromUuid!) {
                    if let toView = bubbleViewForUuid(uuid: toUuid!) {
                        // Connect bubbles!
                        let line = LineView(from: fromView, to: toView)
                        superContenView!.insertSubview(line, at: 0)
                        //Lägg till i array för bubblor
                        fromView.lines.append(line)
                        toView.lines.append(line)
                        
                    }
                }
            }
        }
    }
    
    func bubbleViewForUuid(uuid: String) -> BubbleView? {
        for view in (superContenView?.subviews)! {
            if view.isKind(of: BubbleView.self) {
                let bubbleView = view as! BubbleView
                if bubbleView.uuid == uuid {
                    return bubbleView
                }
            }
        }
        return nil
    }
    
    func save() {
        var bubbleViews = [[String:String]]()
        var lineViews = [[String:String]]()
        
        for view in (superContenView?.subviews)! {
            if view.isKind(of: BubbleView.self) {
                let bubbleView = view as! BubbleView
                bubbleViews.append(bubbleView.data())
            } else if view.isKind(of: LineView.self) {
                let lineView = view as! LineView
                lineViews.append(lineView.data())
            }
        }
        if bubbleViews.count > 0 {
            UserDefaults.standard.set(bubbleViews, forKey: "bubbles")
            if lineViews.count > 0 {
                UserDefaults.standard.set(lineViews, forKey: "lines")
            }
        }
        
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        //TODO: Hitta CGPoint och lägg till bubbla
        print("Did tap")
        if selectedBubble != nil {
            selectedBubble?.selected = false
            selectedBubble = nil
        } else {
            let tapPoints = gesture.location(in: superContenView!)
            let bubble = BubbleView(tapPoints)
            bubble.delegate = self
            superContenView!.addSubview(bubble)
            save()
        }
    }
    
    //MARK: - BubbleViewDelegate
    func didPan(_ bubble: BubbleView) {
        save()
    }
    
    func didEdit(_ bubble: BubbleView) {
        // Visa popup med textfält
        let textInput = UIAlertController(title: "Edit bubble text", message: "Enter the text you want in the bubble", preferredStyle: .alert)
        textInput.addTextField { (textField) in
            textField.text = bubble.text
        }
        textInput.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let textField = textInput.textFields![0] as UITextField
            bubble.text = textField.text!
            self.save()
        }))
        
        present(textInput, animated: true, completion: nil)
    }
    
    func didSelect(_ bubble: BubbleView) {
        if selectedBubble != nil {
            if bubble == selectedBubble {
                // Delete bubble
                bubble.delete()
                save()
                
            } else {
                // Connect bubbles!
                let line = LineView(from: selectedBubble!, to: bubble)
                superContenView!.insertSubview(line, at: 0)
                //Lägg till i array för bubblor
                selectedBubble?.lines.append(line)
                bubble.lines.append(line)
                save()
            }
            // Deselect selectedBubble
            selectedBubble?.selected = false
            selectedBubble = nil
        } else {
            selectedBubble = bubble
            selectedBubble?.selected = true
        }
    }
    // MARK: - UIScrollViewDelegate zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return superContenView
    }
}

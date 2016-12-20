//
//  CrossfadeStoryboardSegue.swift
//  View Controller Transition Demo
//
//  Created by John Marstall on 3/20/15.
//  Copyright (c) 2015 John Marstall. All rights reserved.
//

import Cocoa

class CrossfadeStoryboard: NSStoryboardSegue {
    
    // make references to the source controller and destination controller
    override init(identifier: String?,
        source sourceController: Any,
        destination destinationController: Any) {
            var myIdentifier : String
            if identifier == nil {
                myIdentifier = ""
            } else {
                myIdentifier = identifier!
            }
            super.init(identifier: myIdentifier, source: sourceController, destination: destinationController)
    }
    
    
    override func perform() {
        
        // build from-to and parent-child view controller relationships
        let sourceViewController  = self.sourceController as! NSViewController
        let destinationViewController = self.destinationController as! NSViewController
        let containerViewController = sourceViewController.parent! as NSViewController
        
        // add destinationViewController as child
        containerViewController.insertChildViewController(destinationViewController, at: 1)
        
        // get the size of destinationViewController
        var targetSize = destinationViewController.view.frame.size
        targetSize.width = targetSize.width * 2
        targetSize.height = targetSize.height * 2
        let targetWidth = targetSize.width//destinationViewController.view.frame.size.width
        let targetHeight = targetSize.height//destinationViewController.view.frame.size.height
        
        
  
        // prepare for animation
        sourceViewController.view.wantsLayer = true
        destinationViewController.view.wantsLayer = true
        
        //perform transition
        containerViewController.transition(from: sourceViewController, to: destinationViewController, options: NSViewControllerTransitionOptions.crossfade, completionHandler: nil)
        
        //resize view controllers
        sourceViewController.view.animator().setFrameSize(targetSize)
        destinationViewController.view.animator().setFrameSize(targetSize)
        
        //resize and shift window
        let  currentFrame = containerViewController.view.window?.frame

        let currentRect = NSRectToCGRect(currentFrame!)
        let horizontalChange = (targetWidth - containerViewController.view.frame.size.width)/2
        let verticalChange = (targetHeight - containerViewController.view.frame.size.height)/2
        let newWindowRect = NSMakeRect(currentRect.origin.x - horizontalChange, currentRect.origin.y - verticalChange, targetWidth, targetHeight)
        
        
//        if let screen = NSScreen.main() {
//            print("\(screen.visibleFrame)")
//             containerViewController.view.window?.setFrame(screen.visibleFrame, display: true, animate: true)
//        }

        containerViewController.view.window?.setFrame(newWindowRect, display: true, animate: true)
        
        // lose the sourceViewController, it's no longer visible
        containerViewController.removeChildViewController(at: 0)
        
        
        containerViewController.view.window?.styleMask.update(with: NSWindowStyleMask.resizable)
        
    }
    
    
}


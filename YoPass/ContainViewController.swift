//
//  ContainViewController.swift
//  TableShowPass
//
//  Created by yztgx on 16/11/14.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Cocoa

class ContainViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let sourceViewController = mainStoryboard.instantiateController(withIdentifier: "LoginViewController") as! NSViewController
        self.insertChildViewController(sourceViewController, at: 0)
        self.view.addSubview(sourceViewController.view)
        self.view.frame = sourceViewController.view.frame

 
        // Do view setup here.
    }

}

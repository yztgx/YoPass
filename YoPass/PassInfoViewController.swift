//
//  PassInfoViewController.swift
//  YoPass
//
//  Created by yztgx on 16/12/24.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Cocoa

class PassInfoViewController: NSViewController {

    var m_passValue = PassInfo()
    var m_exitExplicit = false
    var m_ImageList = [String]()

    
    func ExitWindow(withCode: Int = 0)
    {
        m_exitExplicit = true
        let application = NSApplication.shared()
        application.stopModal(withCode: withCode)
        self.view.window?.orderOut(nil)
       

    }
    
    override func viewDidDisappear() {
        if (m_exitExplicit == false)
        {
           self.ExitWindow()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        m_ImageList.removeAll()
        m_ImageList.append("pass_1")
        m_ImageList.append("pass_2")
    }
    
}


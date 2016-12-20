//
//  LoginViewController.swift
//  TableShowPass
//
//  Created by yztgx on 16/11/14.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    @IBOutlet var passText: NSSecureTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        // Do view setup here.
    }
    
    @IBAction func loginClick(_ sender: AnyObject) {
        CommonSetting.m_passMD5 = passText.stringValue.md5
        CommonSetting.m_passMD5_16 = passText.stringValue.md5_16
        
        let foperate = FileOperate(fileName: CommonSetting.m_filePass, isLocal: true)
        if foperate.isFileExist()
        {
            if foperate.CheckFileValid()
            {
                performSegue(withIdentifier: "toMainSegue", sender: nil)
            }
            else
            {
                print("password error!")
            }
          
        }
        else
        {
            foperate.CreateNewFile()
            performSegue(withIdentifier: "toMainSegue", sender: nil)
        }
    }
    @IBAction func exitClick(_ sender: AnyObject) {
        exit(0)
    }
}

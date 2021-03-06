//
//  WebPassInfoViewController.swift
//  YoPass
//
//  Created by yztgx on 16/11/30.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Cocoa

class WebPassInfoViewController: PassInfoViewController,NSTextFieldDelegate {

    @IBOutlet weak var nameText: NSTextField!
    
    @IBOutlet weak var urlText: NSTextField!

    @IBOutlet weak var userText: NSTextField!
    
    @IBOutlet weak var passText: NSTextField!

    @IBOutlet weak var passLevel: NSLevelIndicator!
    
    @IBOutlet weak var mailText: NSTextField!
    
    @IBOutlet weak var telText: NSTextField!
    
    @IBOutlet weak var imagePop: NSPopUpButton!
    
    @IBOutlet weak var importCheckButton: NSButton!
    
    @IBOutlet weak var favorityCheckButton: NSButton!
    
    @IBOutlet var markText: NSTextView!
    
   // var m_passValue = PassInfo()
    
 //   var m_ImageList = [String]()
    
    //var m_exitExplicit = false
    //点击系统关闭按钮，没有调用stopModal导致假死，使用m_exitExplicit变量判断是否调用过stopModal


    func InitImagePopButtom()
    {
        imagePop.removeAllItems()
        for index in 0..<m_ImageList.count
        {
            imagePop.addItem(withTitle: "")
            imagePop.item(at: index)?.tag = index
            imagePop.item(at: index)?.image = NSImage(named: m_ImageList[index])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        InitImagePopButtom()
        passText.delegate = self
         // Do view setup here.
        
    }
    
    override func viewDidAppear()
    {
        importCheckButton.allowsMixedState = false
        favorityCheckButton.allowsMixedState = false
        if m_passValue.ID > 0
        {
            nameText.stringValue = m_passValue.Name
            urlText.stringValue = m_passValue.URL
            userText.stringValue = m_passValue.Username
            passText.stringValue = m_passValue.Password
            mailText.stringValue = m_passValue.Mail
            telText.stringValue = m_passValue.Tel
            markText.string = m_passValue.Mark
            importCheckButton.state = m_passValue.Important ? NSOnState:NSOffState
            favorityCheckButton.state = m_passValue.Favorite ? NSOnState:NSOffState
            

            passLevel.doubleValue = Double(CommonFunc.CheckPassSafe(password: m_passValue.Password))
            for index in 0..<m_ImageList.count
            {
                if m_ImageList[index] == m_passValue.Image
                {
                    imagePop.selectItem(at: index)
                    break
                }
            }
            
            
            
        }

    }
    
    
    override func controlTextDidChange(_ obj: Notification) {
        
         passLevel.doubleValue = Double(CommonFunc.CheckPassSafe(password: passText.stringValue))
        
    }
    @IBAction func okClick(_ sender: Any) {
        let dialogSure = NSAlert()
        dialogSure.alertStyle = NSAlertStyle.warning
        dialogSure.messageText = "Warning"
        dialogSure.informativeText = "are you sure Modify this pass?"
        
        dialogSure.addButton(withTitle: "Cancel")
        dialogSure.addButton(withTitle: "OK")
        let retCode = dialogSure.runModal()
        
        if (retCode == NSAlertFirstButtonReturn)
        {
            print("cancel")
            //直接退出
            return
        }else if retCode == NSAlertSecondButtonReturn{
            print("OK")
        }

        m_passValue.Name = nameText.stringValue
        m_passValue.URL = urlText.stringValue
        m_passValue.Username = userText.stringValue
        m_passValue.Password = passText.stringValue
        m_passValue.Mail = mailText.stringValue
        m_passValue.Tel = telText.stringValue
        m_passValue.Mark = markText.string!
        if importCheckButton.state == NSOnState
        {
            m_passValue.Important = true
        }
        else
        {
             m_passValue.Important = false
        }
        
        if favorityCheckButton.state == NSOnState
        {
            m_passValue.Favorite = true
        }
        else
        {
            m_passValue.Favorite = false
        }
        m_passValue.Image = m_ImageList[(imagePop.selectedItem?.tag)!]
        

        
        m_passValue.CategoryID = CATEGORY_WEB
      
                
        self.ExitWindow(withCode: 1)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
      

      
      self.ExitWindow()

    }
    
    
}

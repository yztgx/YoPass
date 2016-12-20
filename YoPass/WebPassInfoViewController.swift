//
//  WebPassInfoViewController.swift
//  YoPass
//
//  Created by yztgx on 16/11/30.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Cocoa

class WebPassInfoViewController: NSViewController,NSTextFieldDelegate {

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
    
    var m_passValue = PassInfo()
    
    var m_ImageList = [String]()
    


    func InitImagePopButtom()
    {
        m_ImageList.removeAll()
        m_ImageList.append("pass_1")
         m_ImageList.append("pass_2")
        
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
            importCheckButton.state = m_passValue.Important ? NSOnState:NSOffState
            favorityCheckButton.state = m_passValue.Favorite ? NSOnState:NSOffState
            

            passLevel.doubleValue = Double(CheckPassSafe(password: m_passValue.Password))
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
        
         passLevel.doubleValue = Double(CheckPassSafe(password: passText.stringValue))
        
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
      
        
        
        let application = NSApplication.shared()
        application.stopModal(withCode: 1)
        self.view.window?.orderOut(nil)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        let application = NSApplication.shared()
        application.stopModal(withCode: 0)
        self.view.window?.orderOut(nil)

    }
    
    
    //计算规则：1-5分，1极不安全，5最安全
    //默认1分、包含数字+1分，包含字母+1分，长度超过6 +1,包含特殊符号+1
    //每个字符之间相减值相同者减1分
    
    func CheckPassSafe(password: String)->Int
    {
        var numpassList = [UInt32]()
        var numReduceList = [Int]()
        var numCount = 0
        var numNum = 0
        var numCharUpper = 0
        var numCharLoser = 0
        var numSpecial = 0
        var numReduceCompare = -1
        for ch in password.unicodeScalars
        {
            numpassList.append(UnicodeScalar(ch).value)
            
        }
        
        if numpassList.count >= 6
        {
            numCount = 1
        }
        else
        {
            return 1
        }
        
        var oldnum: UInt32 = 0
        var reduce: Int = 0
        for num in numpassList
        {
            if (num >=  UnicodeScalar("0")!.value && num <=  UnicodeScalar("9")!.value)
            {
                numNum =  1
            }else if (num >=  UnicodeScalar("a")!.value && num <=  UnicodeScalar("z")!.value)
            {
                numCharLoser = 1
                
            }else if (num >=  UnicodeScalar("A")!.value && num <=  UnicodeScalar("Z")!.value)
            {
                numCharUpper = 1
            }
            else{
                numSpecial = 1
            }
            if oldnum != 0
            {
                reduce = Int(num) - Int(oldnum)
                numReduceList.append(reduce)
            }
            oldnum = num
        }
        
        if numReduceList.count > 2
        {
            let numReduceTmp = numReduceList[0]
            for numReduceIndex in numReduceList
            {
                if numReduceTmp != numReduceIndex
                {
                    numReduceCompare = 0
                    break
                }
            }
        }
        
        
        return numCount+numNum+numCharUpper+numCharLoser+numSpecial+numReduceCompare
    }
}

//
//  MarkPassViewController.swift
//  YoPass
//
//  Created by yztgx on 16/12/21.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Cocoa

class MarkPassInfoViewController: PassInfoViewController {

    @IBOutlet weak var nameText: NSTextField!
    
    @IBOutlet var markText: NSTextView!
    
    @IBOutlet weak var imagePop: NSPopUpButton!
    
    @IBOutlet weak var importCheckButton: NSButton!
    
    @IBOutlet weak var favorityCheckButton: NSButton!
    
   // var m_passValue = PassInfo()
    
  //  var m_ImageList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitImagePopButtom()
        
         // Do view setup here.
    }
    
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
    
    override func viewDidAppear()
    {
        importCheckButton.allowsMixedState = false
        favorityCheckButton.allowsMixedState = false
        if m_passValue.ID > 0
        {
            nameText.stringValue = m_passValue.Name
            markText.string = m_passValue.Mark
            importCheckButton.state = m_passValue.Important ? NSOnState:NSOffState
            favorityCheckButton.state = m_passValue.Favorite ? NSOnState:NSOffState
            
            
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
        m_passValue.URL = "-"
        m_passValue.Username = "-"
        m_passValue.Password = "-"
        m_passValue.Mail = "-"
        m_passValue.Tel = "-"
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
        
        
        
        m_passValue.CategoryID = CATEGORY_MARK
        
        ExitWindow(withCode: 1)
    }
    
    @IBAction func cancelClick(_ sender: Any)
    {
        
       ExitWindow()
    }
    
}

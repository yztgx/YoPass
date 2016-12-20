//
//  MainViewController.swift
//  YoPass
//
//  Created by yztgx on 16/11/24.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Cocoa


let COLUMN_CELL_IDENTIFIER_NAME = "cellName"
let COLUMN_CELL_IDENTIFIER_USER = "cellUser"
let COLUMN_CELL_IDENTIFIER_PASS = "cellPass"
let COLUMN_CELL_IDENTIFIER_TEL = "cellTel"
let COLUMN_CELL_IDENTIFIER_MAIL = "cellMail"
let COLUMN_CELL_IDENTIFIER_URL = "cellURL"
let COLUMN_CELL_IDENTIFIER_ID = "cellID"


class MainViewController: NSViewController,NSWindowDelegate {
    
   // var passwordDate = PasswordDate()
    var m_dataManager = DataManager()
    var m_categoryList = [CategoryInfo]()
    var m_passList = [PassInfo]()
    
    var sortAscending = true
    
    var currentOrderKey = Order.ID.rawValue
    var currentCategory :Int = 0
    
   // @IBOutlet weak var passMenu: NSMenu!
    
    @IBOutlet weak var tableView_Pass: NSTableView!
    @IBOutlet weak var tableView_Category: NSTableView!
    
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize
    {
        if self.isViewLoaded
        {
            let winRect = sender.contentLayoutRect
            
            var viewOrigin = winRect.origin
            viewOrigin.y = winRect.origin.y-20
  
            if (sender.styleMask.rawValue & NSFullScreenWindowMask.rawValue == NSFullScreenWindowMask.rawValue )
            {
                print("in full screen")
                viewOrigin.y = winRect.origin.y
            }
            self.view.setFrameOrigin(viewOrigin)
            
            self.view.setFrameSize(frameSize)
            
        }
        return frameSize
    }
    
    
    override func viewWillAppear() {
        //设置Categroy Table默认选择第一行
        let indexes = IndexSet(integer:0)
        tableView_Category.selectRowIndexes(indexes,byExtendingSelection:false)
      
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView_Pass.dataSource = self
        tableView_Pass.delegate = self
        tableView_Pass.target = self
        tableView_Category.dataSource = self
        tableView_Category.delegate = self
        
  
        NSApplication.shared().windows.first?.delegate = self
        
        m_categoryList = m_dataManager.GetAllCategory()
        m_passList = m_dataManager.GetPassbyCategory(categoryID: CATEGORY_ALL)
        
        
        for passValue in m_passList
        {
            print("URL:\(passValue.URL) \nName: \(passValue.Name)\nPass: \(passValue.Password) \n\n")
            
        }
        InitTableView()
    


        
        NSEvent.addLocalMonitorForEvents(matching: .rightMouseDown) { (aEvent) -> NSEvent? in
            self.rightMouseDown(with:  aEvent)
            return aEvent
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    
    struct ColumnInfo
    {
        var title: String = ""
        var identifier: String = ""
        var minWidth: CGFloat = 100
        var sortDescriptor: NSSortDescriptor? = nil
    }
    var m_columnInfoArray = [ColumnInfo]()
    
    func InitTableView()
    {
 
        var tableColumn = NSTableColumn()
        var columnInfoValue = ColumnInfo()
        
        columnInfoValue.title = "Name"
        columnInfoValue.identifier = COLUMN_CELL_IDENTIFIER_NAME
        columnInfoValue.sortDescriptor = NSSortDescriptor(key: Order.Name.rawValue, ascending: true)
        m_columnInfoArray.append(columnInfoValue)
        
        columnInfoValue.title = "User"
        columnInfoValue.identifier = COLUMN_CELL_IDENTIFIER_USER
        columnInfoValue.sortDescriptor = NSSortDescriptor(key: Order.User.rawValue, ascending: true)
        m_columnInfoArray.append(columnInfoValue)
        
        
        columnInfoValue.title = "Pass"
        columnInfoValue.identifier = COLUMN_CELL_IDENTIFIER_PASS
        columnInfoValue.sortDescriptor = NSSortDescriptor(key: Order.Pass.rawValue, ascending: true)
        m_columnInfoArray.append(columnInfoValue)
        
        columnInfoValue.title = "Tel"
        columnInfoValue.identifier = COLUMN_CELL_IDENTIFIER_TEL
        columnInfoValue.sortDescriptor = NSSortDescriptor(key: Order.Tel.rawValue, ascending: true)
         m_columnInfoArray.append(columnInfoValue)
        
        columnInfoValue.title = "Mail"
        columnInfoValue.identifier = COLUMN_CELL_IDENTIFIER_MAIL
        columnInfoValue.sortDescriptor = NSSortDescriptor(key: Order.Mail.rawValue, ascending: true)
        m_columnInfoArray.append(columnInfoValue)

        columnInfoValue.title = "URL"
        columnInfoValue.identifier = COLUMN_CELL_IDENTIFIER_URL
        columnInfoValue.sortDescriptor = NSSortDescriptor(key: Order.URL.rawValue, ascending: true)
        m_columnInfoArray.append(columnInfoValue)
        
        tableView_Pass.tableColumn(withIdentifier: "cellImageText")?.isHidden = true
        tableView_Pass.tableColumn(withIdentifier: "cellText")?.isHidden = true
        
        
        for columnInfoValue in m_columnInfoArray
        {

            tableColumn = NSTableColumn(identifier: columnInfoValue.identifier)
            tableColumn.title = columnInfoValue.title
            tableColumn.minWidth = columnInfoValue.minWidth
            tableColumn.sortDescriptorPrototype = columnInfoValue.sortDescriptor
            print("add column:\(tableColumn.identifier)")
            tableView_Pass.addTableColumn(tableColumn)

        }
        
       // HidePassTableColumn(passtableshow: PASSTABLE_SHOW_ALL)
        tableView_Pass.sizeToFit()
        tableView_Pass.sizeLastColumnToFit()
    }
    
  
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
   


    func reloadPassList(order: Order.RawValue)
    {
        currentOrderKey = order
        SortList(Key: Order(rawValue: order)!,sortAsc:sortAscending,passList: &m_passList)
        tableView_Pass.reloadData()
        
    }
    
    func showPassbyClass(categoryID: Int)
    {
        m_passList = m_dataManager.GetPassbyCategory(categoryID: categoryID)
        tableView_Pass.reloadData()
    }
    
    @IBAction func RemovePass(_ sender: AnyObject)
    {
        if tableView_Pass.selectedRow >= m_passList.count || tableView_Pass.selectedRow < 0
        {
            return
        }
        
        let dialogSure = NSAlert()
        dialogSure.alertStyle = NSAlertStyle.warning
        dialogSure.messageText = "Warning"
        dialogSure.informativeText = "are you sure remove this pass?"
        
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
        
 
        var selectIndex = Int()
        var selectPassID = Int()
        selectIndex = tableView_Pass.selectedRow
        selectPassID = m_passList[selectIndex].ID
        m_passList.remove(at: selectIndex)
        m_dataManager.RemovePass(passID: selectPassID)
        tableView_Pass.reloadData()
        
        
    }
    
    @IBAction func AddNewPass(_ sender: AnyObject)
    {
        

        
        
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Pass", bundle: nil)
        let passWindowController = mainStoryboard.instantiateController(withIdentifier: "WebPass") as! NSWindowController
        
        if let passWindow = passWindowController.window{
            
            var passValue: PassInfo
            let passViewController = passWindowController.contentViewController as! WebPassInfoViewController
            
            let application = NSApplication.shared()
            let exitCode = application.runModal(for: passWindow)
            
            if (exitCode == 1)
            {
                passValue = passViewController.m_passValue
                let cateIndex = tableView_Category.selectedRow
                if (cateIndex >= 0 )
                {
                    if (m_categoryList[cateIndex].ID == passValue.CategoryID
                        || m_categoryList[cateIndex].ID == CATEGORY_ALL
                        || (m_categoryList[cateIndex].ID == CATEGORY_FAVORITE && passValue.Favorite == true))
                    {
                        m_passList.append(passValue)
                    }
                }
               
                let _ = m_dataManager.AddPass(passValue:  passValue)
                tableView_Pass.reloadData()
            }
        }
    }
    


    
    override func rightMouseDown(with event: NSEvent) {
       //  NSMenu.popUpContextMenu(passMenu, with: event, for: self.view)
        var mouseDownPosition: CGPoint?
        mouseDownPosition = event.locationInWindow//convertPoint(theEvent.locationInWindow, fromView: nil)

    //    passMenu.popUp(positioning: passMenu, at: mouseDownPosition, in: NSView?)
      
        print("table view fram x:\(tableView_Pass.frame.origin.x) y:\(tableView_Pass.frame.origin.y)")
        print("right mouse click x:\(mouseDownPosition?.x) y:\(mouseDownPosition?.y)")
    }

    
    @IBAction func dbClick(_ sender: AnyObject) {
        

        if tableView_Pass.selectedRow >= m_passList.count || tableView_Pass.selectedRow < 0
        {
            return
        }
        
        var passValue = m_passList[tableView_Pass.selectedRow]

        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Pass", bundle: nil)
        let passWindowController = mainStoryboard.instantiateController(withIdentifier: "WebPass") as! NSWindowController
        
        if let passWindow = passWindowController.window{
            
            
            let passViewController = passWindowController.contentViewController as! WebPassInfoViewController
            passViewController.m_passValue = passValue
            
            let application = NSApplication.shared()
            let exitCode = application.runModal(for: passWindow)
            
            if (exitCode == 1)
            {
                passValue = passViewController.m_passValue

                m_passList[tableView_Pass.selectedRow] =  passValue
                let _ = m_dataManager.ModifyPass(passValue: passValue)
                tableView_Pass.reloadData()
            }
        }
        
        
        
    }
    
    
}

extension MainViewController: NSTableViewDataSource
{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.tableView_Category
        {
            return m_categoryList.count
        }
        return m_passList.count
    }
}


extension MainViewController: NSTableViewDelegate
{
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if tableView == self.tableView_Category
        {
            return 100
        }
        return 20
    }
    
    
    //类表格选中时，往passwordDate.passList中添加对应class的数据
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if tableView == self.tableView_Category
        {
            let classValue = m_categoryList[row]
            showPassbyClass(categoryID: classValue.ID)

            currentCategory = Int(classValue.ID)
            print("select \(m_categoryList[row])")
        }
        return true
    }
    
    
    //往表格中添加数据,分别添加类表格和pass内容表
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage? = nil
        var text: String = ""
        var cellIdentifier: String = ""
        
        
        if tableView == self.tableView_Category
        {
            let categoryItem = m_categoryList[row]
            if let cellClass = tableView.make(withIdentifier: "cellClass", owner: self) as? ClassCellView{
                cellClass.classShowName?.stringValue = categoryItem.Name
                cellClass.classImage?.image = NSImage(named: categoryItem.Image)
                return cellClass
            }
        }
        if tableView == self.tableView_Pass
        {
            guard row < m_passList.count else
            {
                return nil
            }
            let item = m_passList[row]
            
            
            //print("\(tableColumn?.identifier)")
            switch tableColumn!.identifier{
            case COLUMN_CELL_IDENTIFIER_NAME:
                image = NSImage(named: item.Image)
                text = "\(item.Name)"
                cellIdentifier = "cellImageText"
            case COLUMN_CELL_IDENTIFIER_USER:
                text = item.Username
                cellIdentifier = "cellText"
            case COLUMN_CELL_IDENTIFIER_PASS:
                text = item.Password
                cellIdentifier = "cellText"
            case COLUMN_CELL_IDENTIFIER_URL:
                text = item.URL
                cellIdentifier = "cellText"
            case COLUMN_CELL_IDENTIFIER_TEL:
                text = item.Tel
                cellIdentifier = "cellText"
            case COLUMN_CELL_IDENTIFIER_MAIL:
                text = item.Mail
                cellIdentifier = "cellText"
            case "cellText":
                text = String(item.ID)
                cellIdentifier = "cellText"
            default:
                return nil
            }
            if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView{
                cell.textField?.stringValue = text
                //print("textField:\(cell.textField?.stringValue)")
                cell.imageView?.image = image
                return cell
            }
        }
        return nil
        
    }
    
    
    //表格排序
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        
        sortAscending = sortDescriptor.ascending
        reloadPassList(order: sortDescriptor.key!)
    }
    
    
    
    
}



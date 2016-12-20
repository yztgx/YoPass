//
//  PassXMLParse.swift
//  TestFile
//
//  Created by yztgx on 16/11/23.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation






class PassXMLParse: NSObject,XMLParserDelegate
{
    var m_parserXML: XMLParser?
    
    var m_passList =  [PassInfo]()
    var m_passValue = PassInfo()
    var m_categoryList = [CategoryInfo]()
    var m_categoryValue = CategoryInfo()
    
    var m_currentNodeName: String = ""
    
    func StartParse(data: Data)
    {
        m_parserXML = XMLParser(data: data)
        if m_parserXML == nil {
            return
        }
        m_parserXML?.delegate = self
        m_parserXML?.parse()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Start Parse XML File")
    }
    func parserDidEndDocument(_ parser: XMLParser) {
       // print("=========================")
//        print("CategoryList:\n \(m_categoryList)")
//        print("PassList: \n \(m_passList)")
        print("End Parse XML File")
    }
    
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        print("start \(elementName),\(attributeDict)")
        //节点解析开始，判断当前节点是否为group，如果是，则开始新一条PassInfo记录
        //如果是其中某一值，则设置当前节点为改值
        if elementName == "PassInfo"
        {
            m_currentNodeName = ""
            
            m_passValue = PassInfo()
            
            if let passid = attributeDict["ID"]
            {
                m_passValue.ID = Int(passid)!
            }
            if let cateid = attributeDict["CategoryID"]
            {
                m_passValue.CategoryID = Int(cateid)!
            }
            if let favorite = attributeDict["Favorite"]
            {
                if favorite == "1"
                {
                    m_passValue.Favorite = true
                }
                else
                {
                    m_passValue.Favorite = false
                }
            }
            if let important = attributeDict["Important"]
            {
                if important == "1"
                {
                    m_passValue.Important = true
                }
                else
                {
                    m_passValue.Important = false
                }
            }
            

        }
        else if elementName == "Category"
        {
            m_currentNodeName = ""
            m_categoryValue = CategoryInfo()
            if let id = attributeDict["ID"]
            {
                m_categoryValue.ID = Int(id)!
            }
            if let isDefault = attributeDict["Default"]
            {
                if (isDefault == "0")
                {
                    m_categoryValue.isDefault = false
                }
                else
                {
                    m_categoryValue.isDefault = true
                }
            }
            if let name = attributeDict["Name"]
            {
                m_categoryValue.Name = name
            }
            if let image = attributeDict["Image"]
            {
                m_categoryValue.Image = image
            }
            print("\(m_categoryValue)")
        }
        else
        {
            m_currentNodeName = elementName
            
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        print("end \(elementName)")
        
        //节点解析结束，设置当前节点为空，防止误解析
        if elementName == "PassInfo"
        {
            m_passList.append(m_passValue)
            m_currentNodeName = ""
        }else if elementName == "Category"
        {
            m_categoryList.append(m_categoryValue)
            m_currentNodeName = ""
        }

        
        
    }

    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        print("\(m_currentNodeName):\(attributeName):\(elementName):\(type):\(defaultValue)")

    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("\(m_currentNodeName):\(string)")
        let strValue = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !strValue.isEmpty
        {
            switch m_currentNodeName
            {
                case "Name": m_passValue.Name = strValue
                case "Username": m_passValue.Username = strValue
                case "Password": m_passValue.Password = strValue
                case "URL": m_passValue.URL = strValue
                case "Tel": m_passValue.Tel = strValue
                case "Mail":m_passValue.Mail = strValue
                case "Serial": m_passValue.Serial = strValue
                case "Image" :m_passValue.Image = strValue
            default:break
            }
        }
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
}

class XMLCombine
{
    var m_categoryList = [CategoryInfo]()
    var m_passList = [PassInfo]()
    
    init(categoryList: [CategoryInfo],passList: [PassInfo])
    {
        m_categoryList = categoryList
        m_passList = passList

    }
 
    
    func Combine()->String
    {
        let datainfo = SetDataBaseInfo()
        let cateList = SetCategoryList(categoryList: m_categoryList)
        let passlist = SetPassList(passList: m_passList)
        
        let root = XMLElement(name: "DataBase")
      
        root.addChild(datainfo)
        root.addChild(cateList)
        root.addChild(passlist)
        
        let xmlnewDoc = XMLDocument(rootElement: root)
        xmlnewDoc.isStandalone = true
        xmlnewDoc.characterEncoding = "UTF-8"
        return (xmlnewDoc.xmlString)
    }
    
    
    private func SetDataBaseInfo()->XMLElement
    {
        let dataBaseInfo = ["Software":"YoPass",
                            "Ver":"1.0",
                            "User":" ",
                            "Date":" "]
        let nodeBase = XMLElement(name: "DataBaseInfo")
        //        <DataBaseInfo>
        //        <SoftName>YoPass</SoftName>		//用来校验数据解密是否正确
        //        <Ver>1.0</Ver>
        //        <User></User>	//当前用户
        //        <Date></Date>	//数据库修改日期
        //        </DataBaseInfo>
        
        var nodeBaseChild = XMLElement()
        for (key,value) in dataBaseInfo
        {
            nodeBaseChild = XMLElement()
            nodeBaseChild.name = key
            nodeBaseChild.stringValue = value
            nodeBase.addChild(nodeBaseChild)
        }
        return nodeBase
        
    }
    
    private  func SetCategoryList(categoryList: [CategoryInfo])->XMLElement
    {
        let nodeCategoryList = XMLElement(name: "CategoryList")
        var nodeCategory: XMLElement
        //    <CategoryList>
        //  		<Category ID = "0" Default= "1" Name="ALL" Image= "cate_1" />
        //            <Category ID = "1" Default= "1" Name="Favorite" Image= "cate_2" />
        //                <Category ID = "10" Default= "1" Name="Web" Image= "cate_3" />
        //                    <Category ID = "11" Default= "1" Name="Software" Image= "cate_4" />
        //                        <Category ID = "12" Default= "1" Name="Bank" Image= "cate_5" />
        //                            </CategoryList>
        var attr = [String: String]()
        for categoryValue in categoryList
        {
            nodeCategory = XMLElement(name: "Category")
            attr["ID"] = String(categoryValue.ID)
            attr["Default"]  = categoryValue.isDefault ?"1":"0"
            attr["Name"] = categoryValue.Name
            attr["Image"] = categoryValue.Image
            nodeCategory.setAttributesWith(attr)
            nodeCategoryList.addChild(nodeCategory)
        }
        //print("node Category\n\(nodeCategoryList)")
        return nodeCategoryList
    }
    
    private func SetPassList(passList: [PassInfo])->XMLElement
    {
        let nodepassList = XMLElement(name: "PassList")
        
        var nodepass: XMLElement
        //    <Passinfo ID = "1" CategoryID= "10" Important = "1" Favorite = "1">
        //    <Name>google</Name>
        //    <URL>https://www.google.com</URL>
        //    <Username>superman</Username>
        //    <Password>123456</Password>
        //    <Tel>13800138000</Tel>
        //    <Mail>superman@gmail.com</Mail>
        //    <Image>pass_1</Image>
        //    </Passinfo>
        
        var attr = [String: String]()
        var passItemName : XMLElement
        var passItemURL: XMLElement
        var passItemUserName : XMLElement
        var passItemPassword : XMLElement
        var passItemTel :XMLElement
        var passItemMail: XMLElement
        var passItemImage: XMLElement
        
        for passValue in passList
        {
            nodepass = XMLElement(name: "PassInfo")
            passItemName = XMLElement(name: "Name", stringValue: passValue.Name)
            passItemURL = XMLElement(name: "URL", stringValue: passValue.URL)
            passItemUserName = XMLElement(name: "Username", stringValue: passValue.Username)
            passItemPassword = XMLElement(name: "Password", stringValue: passValue.Password)
            passItemTel = XMLElement(name: "Tel", stringValue: passValue.Tel)
            passItemMail = XMLElement(name: "Mail", stringValue: passValue.Mail)
            passItemImage = XMLElement(name: "Image", stringValue: passValue.Image)
            nodepass.addChild(passItemName)
            nodepass.addChild(passItemURL)
            nodepass.addChild(passItemUserName)
            nodepass.addChild(passItemPassword)
            nodepass.addChild(passItemTel)
            nodepass.addChild(passItemMail)
            nodepass.addChild(passItemImage)
            
            attr["ID"] = String(passValue.ID)
            attr["CategoryID"]  = String(passValue.CategoryID)
            attr["Important"] = passValue.Important ?"1":"0"
            attr["Favorite"] = passValue.Favorite ?"1":"0"
            nodepass.setAttributesWith(attr)
            nodepassList.addChild(nodepass)
        }
        //print("node passList\n\(nodepassList)")
        return nodepassList
    }

    
}

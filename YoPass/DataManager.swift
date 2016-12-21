//
//  DataManager.swift
//  TestFile
//
//  Created by yztgx on 16/11/23.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation
import AppKit



struct PassInfo{
    var ID: Int = 0
    var CategoryID: Int = 0
    var Important: Bool = false
    var Favorite: Bool = false
    var Name: String = ""
    var URL: String = ""
    var Username: String = ""
    var Password: String = ""
    var Tel: String = ""
    var Mail: String = ""
    var Serial: String = ""
    var Image: String = ""
    var Mark: String = ""
}

struct CategoryInfo{
    var ID: Int = 0
    var Name: String = ""
    var Image: String = ""
    var isDefault: Bool = false
    var ColumnIdentifiers = [String]()
    init()
    {
    
        
    }
    init(id: Int, name: String, isdefault: Bool, image: String)
    {
        self.ID = id
        self.Name = name
        self.isDefault = isdefault
        self.Image = image
        
    }
    
}

enum Order : String{
    case Name
    case URL
    case Tel
    case Mail
    case Pass
    case ID
    case User
    
}

let CATEGORY_ALL        = 0
let CATEGORY_FAVORITE   = 1
let CATEGORY_WEB        = 10
let CATEGORY_SOFTWARE   = 11





    
func SortList(Key: Order,sortAsc: Bool, passList: inout [PassInfo])
{
    if sortAsc {
        switch Key {
        case .Name:
            passList.sort(by: {$0.Name > $1.Name})
        case .ID:
            passList.sort(by: {$0.ID > $1.ID})
        case .Pass:
            passList.sort(by: {$0.Password > $1.Password})
        case .Mail:
            passList.sort(by: {$0.Mail > $1.Mail})
        case .Tel:
            passList.sort(by: {$0.Tel > $1.Tel})
        case .URL:
            passList.sort(by: {$0.URL > $1.URL})
        case .User:
            passList.sort(by: {$0.Username > $1.Username})
        }
    }else{
        switch Key {
        case .Name:
            passList.sort(by: {$0.Name < $1.Name})
        case .ID:
            passList.sort(by: {$0.ID < $1.ID})
        case .Pass:
            passList.sort(by: {$0.Password < $1.Password})
        case .Mail:
            passList.sort(by: {$0.Mail < $1.Mail})
        case .Tel:
            passList.sort(by: {$0.Tel < $1.Tel})
        case .URL:
            passList.sort(by: {$0.URL < $1.URL})
        case .User:
            passList.sort(by: {$0.Username < $1.Username})
        }
        
    }
}
    


class DataManager: NSObject
{
    private var m_categoryList = [CategoryInfo]()
    private var m_passList_ALL = [PassInfo]()
    let file = FileOperate(fileName: CommonSetting.m_filePass,isLocal: true)

    override init()
    {
        //file.DeleteFile()       //swift copy函数无法覆盖，只能先删除
        //file.CopyFile()   
    
        let data = file.ReadFile()
       
        let passXML = PassXMLParse()
        passXML.StartParse(data: data!)
        
        m_categoryList = passXML.m_categoryList
        m_passList_ALL = passXML.m_passList

     }
    
    func GetAllCategory()->[CategoryInfo]
    {
 

        return m_categoryList
    }
    
//    func FillCategoryColumn()
//    {
//        var  categoryinfo = CategoryInfo()
//        for index in 0..<m_categoryList.count
//        {
//            categoryinfo = m_categoryList[index]
//            switch categoryinfo.ID {
//            case CATEGORY_ALL:
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_NAME)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_USER)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_PASS)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_URL)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_TEL)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_MAIL)
//
//            case CATEGORY_FAVORITE:
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_NAME)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_USER)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_PASS)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_URL)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_TEL)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_MAIL)
//            case CATEGORY_WEB:
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_NAME)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_USER)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_PASS)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_URL)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_TEL)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_MAIL)
//            case CATEGORY_SOFTWARE:
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_NAME)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_USER)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_PASS)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_TEL)
//                categoryinfo.ColumnIdentifiers.append(COLUMN_CELL_IDENTIFIER_MAIL)
//            default:
//                break
//                
//            }
//            m_categoryList[index] = categoryinfo
//
//        }
//    
//    }
    
    func GetColumnsbyCategory(categoryID:Int)->[String]
    {
        for category in m_categoryList
        {
            if category.ID == categoryID{
                return category.ColumnIdentifiers
            }
        }
        return []
    }
    
    func GetPassbyCategory(categoryID:Int)->[PassInfo]
    {
        var passList = [PassInfo]()
        
        
        for passValue in m_passList_ALL{
            if (categoryID == CATEGORY_ALL){
                passList = m_passList_ALL
                break
                
            }
            else if (categoryID == CATEGORY_FAVORITE)
            {
                if passValue.Favorite == true{
                    passList.append(passValue)
                }
                
            }
            else if (categoryID >= 10)
            {
                if passValue.CategoryID == categoryID{
                    passList.append(passValue)
                }
            }
        }
        
        
        return passList
    }
    
    func ModifyPass(passValue: PassInfo)->Bool
    {
        for index in 0..<m_passList_ALL.count{
            if  m_passList_ALL[index].ID == passValue.ID{
                m_passList_ALL[index] = passValue
                SavePassFile()
                return true
            }
        }
        
        return false
    }
    
    func AssignNewPassID()->Int
    {
        var maxID = 1
       
        for passValue_index in m_passList_ALL{
            if passValue_index.ID > maxID{
                maxID = passValue_index.ID
            }
            maxID = maxID + 1
        }
        return maxID
    }
    
    func AddPass(passValue: PassInfo)
    {
        m_passList_ALL.append(passValue)
        SavePassFile()
        
    }
    
    
    func RemovePass(passID: Int)
    {

        for index in 0..<m_passList_ALL.count{
            if m_passList_ALL[index].ID == passID{
                m_passList_ALL.remove(at: index)
                
                break
            }
        }
        SavePassFile()
    }
    
    func SavePassFile()
    {
        let xmlCombine = XMLCombine(categoryList: m_categoryList,passList: m_passList_ALL)
        let strXML = xmlCombine.Combine()
        
        file.WriteFile(strdata: strXML)
        
        
    }
   

    
  
}

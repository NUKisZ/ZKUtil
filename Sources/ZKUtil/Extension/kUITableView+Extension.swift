//
//  kUITableView+Extension.swift
//  LoveDiary
//
//  Created by 张坤 on 2019/4/30.
//  Copyright © 2019 张坤. All rights reserved.
//

import Foundation
import UIKit
extension UITableView{
    public func scrollToBottom() {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section) - 1
        if section < 0 || row < 0 {
            return
        }
        let path = IndexPath(row: row, section: section)
        self.scrollToRow(at: path, at: .top, animated: false)
    }
}
/**
 向tableView 注册 UITableViewCell

 - parameter tableView: tableView
 - parameter cell:      要注册的类名
 */
public func regClass(_ tableView:UITableView , cell:AnyClass)->Void {
    tableView.register( cell, forCellReuseIdentifier: "\(cell)");
}
/**
 从tableView缓存中取出对应类型的Cell
 如果缓存中没有，则重新创建一个

 - parameter tableView: tableView
 - parameter cell:      要返回的Cell类型
 - parameter indexPath: 位置

 - returns: 传入Cell类型的 实例对象
 */
public func getCell<T: UITableViewCell>(_ tableView:UITableView ,cell: T.Type ,indexPath:IndexPath) -> T {
    return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T ;
}
/**
 从tableView缓存中取出对应类型的Cell
 如果缓存中没有，则重新创建一个

 - parameter tableView: tableView
 - parameter identifier:cellID
 - parameter style:     类型
 - returns: 传入Cell类型的 实例对象
 */
public func getCell<T: UITableViewCell>(_ tableView:UITableView,cell:T.Type ,style:UITableViewCell.CellStyle = .default,identifier:String) -> T {
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? T
    if cell == nil{
        cell = T(style: style, reuseIdentifier: identifier)
    }
    return cell!
}


//
//  MenuTextView.swift
//  TextViewDemo
//
//  Created by 冯才凡 on 2020/3/23.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import UIKit

//重新TextView是为了重新订制Menu 让其可以在xib中直接使用
@IBDesignable class MenuTextView: UITextView {
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        setMenu()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setMenu()
    }
    
//要想自定义menu弹框，就得重写下面这两个函数。
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(menuAction) {
            return true
        }
        return false
    }
}

extension MenuTextView {
    func setMenu() {
        let item0 = UIMenuItem(title: "action0", action: #selector(menuAction))
        let item1 = UIMenuItem(title: "action1", action: #selector(menuAction))
        let item2 = UIMenuItem(title: "action2", action: #selector(menuAction))
        let item3 = UIMenuItem(title: "action3", action: #selector(menuAction))
        let item4 = UIMenuItem(title: "action4", action: #selector(menuAction))
        UIMenuController.shared.menuItems = [item0,item1,item2,item3,item4]
    }
    
    
    @objc func menuAction() {
        print("xxx")
    }
}

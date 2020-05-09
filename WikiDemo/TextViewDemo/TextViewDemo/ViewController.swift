//
//  ViewController.swift
//  TextViewDemo
//
//  Created by 冯才凡 on 2020/3/13.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import UIKit

/*
    这个demo意在解决链接长按c复制和点击跳转的问题
 */

class ViewController: UIViewController {
    @IBOutlet weak var textView: MenuTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        //禁止编辑
        textView.isEditable = false
        //高亮电话和链接,其实这样不用代理，点击链接也能直接调起浏览器。
        textView.dataDetectorTypes = [UIDataDetectorTypes.link,UIDataDetectorTypes.phoneNumber]
        //设置高亮的颜色
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.blue]
        
        //
        
        
        
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let sum = Solution().trap([7,5,1])
        print(sum)
        
        super.touchesBegan(touches, with: event)
    }
    
}

extension ViewController : UITextViewDelegate {
    
}

class Solution {
    func trap(_ height: [Int]) -> Int {
        //思路就是记录当前weiz，往后遍历，遍历到比自己高或相等的高度时，如果没有，则取最大高度。然后可计算
        var sum = 0
        var tempSum = 0
        var i = 0
        while i < height.count {
            tempSum = 0
            let leftH = height[i]
            var find = false
            var mostH = 0
            var mostHIndex = i //之后最大高度的下标
            if leftH > 0 {
                for j in (i+1)..<height.count {
                    let rightH = height[j]
                    if j-i==1 && rightH > leftH {
                        //相邻
                        break;
                    }
                    
                    
                    tempSum += rightH
                    
                    if mostH <= rightH {
                        //mostH 取右侧最大值
                        mostH = rightH
                        mostHIndex = j
                    }
                    
                    //先判断有没有比自己高的
                    if rightH >= leftH && (j-i-1) > 0 {
                        print("i:\(i);j:\(j)")
                        tempSum -= rightH
                      //遇到第一个比自己高的柱子就可以开始计算了
                        let temp = leftH * (j-i-1) - tempSum
                        sum += temp
                        //j赋值给i
                        i = j
                        tempSum = 0
                        find = true
                        break;
                        
                    }else if j == height.count - 1 && mostH > 0 && (mostHIndex-i-1) > 0 {
                        //没有比自己高度高的就取最高的那个的
                        tempSum = 0
                        for k in i+1..<mostHIndex {
                            tempSum += height[k]
                        }
                        
                        let temp = mostH * (mostHIndex-i-1) - tempSum
                        sum += temp
                        //j赋值给i
                        i = mostHIndex
                        tempSum = 0
                        find = true
                        break;
                    }
                }
            }
            if !find {
                i += 1
            }
        }
        return sum
    }
}


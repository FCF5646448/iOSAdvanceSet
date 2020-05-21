//
//  ViewController.swift
//  多线程
//
//  Created by 冯才凡 on 2020/5/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let group = DispatchGroup.init()
        
        DispatchQueue.global().async(group: group, qos: DispatchQoS.default, flags: []) {
            
        }
        
        
        let semaphore = DispatchSemaphore(value: 0)
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        semaphore.signal()
        
    }


}


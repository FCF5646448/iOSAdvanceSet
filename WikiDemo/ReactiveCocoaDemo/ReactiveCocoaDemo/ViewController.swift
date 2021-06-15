//
//  ViewController.swift
//  ReactiveCocoaDemo
//
//  Created by 冯才凡 on 2021/6/14.
//  Copyright © 2021 冯才凡. All rights reserved.
//

import UIKit
import ReactiveCocoa
//import ReactiveSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let block: (()->Void) = {
            debugPrint("block")
        }
        
        block()
        
        let viewDidAppearSignal = reactive.signal(for: #selector(viewWillAppear(_:)))
        
        
        
    }


}


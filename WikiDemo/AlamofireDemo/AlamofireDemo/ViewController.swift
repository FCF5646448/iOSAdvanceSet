//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by 冯才凡 on 2020/7/30.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alamofirebtn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 44))
        alamofirebtn.setTitle("alamofire", for: .normal)
        alamofirebtn.setTitleColor(UIColor.white, for: .normal)
        alamofirebtn.addTarget(self, action: #selector(alamofirebtnAction), for: .touchUpInside)
        view.addSubview(alamofirebtn)
        
    }


}

extension ViewController {
    @objc func alamofirebtnAction() {
        self.present(AlamofireTestVC(), animated: true, completion: nil)
    }
}



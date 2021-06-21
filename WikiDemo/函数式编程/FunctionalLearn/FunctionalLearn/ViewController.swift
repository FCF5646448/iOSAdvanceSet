//
//  ViewController.swift
//  FunctionalLearn
//
//  Created by fengcaifan on 2021/6/19.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imagV1: UIImageView!
    
    @IBOutlet weak var imgV2: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        coreImageTest()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}


extension ViewController {
    func coreImageTest() {
        guard let img = UIImage(named: "500x500"),
              let image = CIImage(image: img) else {
            return
        }
        
        let radius = 5.0
        let color = UIColor.red.withAlphaComponent(0.2)
        let blurImage = image.blur(radius: radius)(image)
        let overlaidImg = image.overlay(color: color)(blurImage)
        
        imagV1.image = imagV1.ciImage(blurImage)
        imgV2.image = imagV1.ciImage(overlaidImg)
    }
}


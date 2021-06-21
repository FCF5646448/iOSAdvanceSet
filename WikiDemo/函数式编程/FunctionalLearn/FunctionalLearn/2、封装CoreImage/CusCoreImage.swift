//
//  CusCoreImage.swift
//  FunctionalLearn
//
//  Created by fengcaifan on 2021/6/19.
//

import UIKit
import Foundation
import CoreImage


typealias Filter = (CIImage) -> CIImage

extension CIImage {
    /// 高斯模糊滤镜
    func blur(radius: Double) -> Filter {
        return { img in
            let paramters: [String: Any] = [kCIInputRadiusKey: radius,
                                            kCIInputImageKey: img]
            guard let filter = CIFilter(name: "CIGaussianBlur", parameters: paramters) else {
                fatalError()
            }
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            return outputImage
        }
    }
    
    /// 生成固定颜色的滤镜
    func generate(color: UIColor) -> Filter {
        return {_ in
            let parameters = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
            guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else {
                fatalError()
            }
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            return outputImage
        }
    }
    
    /// 定义一个合成滤镜
    func compositeSourceOver(overlay: CIImage) -> Filter {
        return { image in
            let parameters = [kCIInputBackgroundImageKey: image,
                              kCIInputImageKey: overlay]
            guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else {
                fatalError()
            }
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            return outputImage.cropped(to: image.extent)
        }
    }
    
    /// 颜色重叠滤镜
    func overlay(color: UIColor) -> Filter {
        return {[weak self] image in
            guard let `self` = self else {
                fatalError()
            }
            let overlay = self.generate(color: color)(image).cropped(to: image.extent)
            return self.compositeSourceOver(overlay: overlay)(image)
        }
    }
    
    /// 将两个滤镜合成一个滤镜
    func compose(filter filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
        return { image in
            filter2(filter1(image))
        }
    }
    
    func test() -> CIImage? {
        guard let img = UIImage(named: "500x500"),
              let image = CIImage(image: img) else {
            return nil
        }
        let radius = 5.0
        let color = UIColor.red.withAlphaComponent(0.2)
//        let result = overlay(color: color)(blur(radius: radius)(image))
        
        let blurAndOverlay = compose(filter: blur(radius: radius), with: overlay(color: color))
        return blurAndOverlay(image)
    }
}

/// 
//infix operator >>>: AdditionPrecedence
//extension CIImage {
//    static func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
//        return { image in
//            filter2(filter1(image))
//        }
//    }
//}

typealias ToImage = (CIImage)->UIImage
protocol CIImageProtocol {
    var ciImage: ToImage { get }
}

extension UIImageView: CIImageProtocol {
    var ciImage: ToImage {
        return {cImg in
            let conntext = CIContext(options: nil)
            guard let cgImage = conntext.createCGImage(cImg, from: self.bounds) else{
                fatalError()
            }
            let uImg = UIImage(cgImage: cgImage)
            return uImg
        }
    }
}

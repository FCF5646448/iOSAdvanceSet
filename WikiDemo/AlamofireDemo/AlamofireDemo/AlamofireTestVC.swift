//
//  AlamofireTestVC.swift
//  AlamofireDemo
//
//  Created by 冯才凡 on 2020/8/5.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import UIKit
import Alamofire

/// Alamofire的基础使用
class AlamofireTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        simpletest()
        
    }
    
}

extension AlamofireTestVC {
    func simpletest() {
        AF.request("https://httpbin.org/get").response { (response) in
            
        }
    }
    
    func test2() {
        /// 最主要的请求完整入口
        /*
         参数解析：
         * convertible: URLConvertible // 一个协议类型,可以是这里传入String、URL、URLComponents；
         * method: HTTPMethod // 方法结构体，包含常用的所有方法类型；
         * parameters: Encodable // 实现了Encodable协议的实例；
         * encoder: ParameterEncoder // 实现了ParameterEncoder协议的实例，是编码格式，比如json，这个协议最终生成一个URL；
         * headers: HTTPHeaders //请求头部信息；
         * interceptor: RequestInterceptor // 拦截器，封装了适配器和重试策略；
         * requestModifier: RequestModifier // 封装了一个闭包，可以在闭包里对URLRequest进行处理；
         * return: DataRequest //最终返回一个DataRequest，它是对整个请求过程封装的一个组合类，可以理解为一次请求就生成一个DataRequest，然后它包含了整个请求过程的几乎所有数据。
         */
//         AF.request(URLConvertible, method: HTTPMethod, parameters: <#T##Encodable?#>, encoder: ParameterEncoder, headers: HTTPHeaders?, interceptor: RequestInterceptor?, requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>) -> DataRequest?
    }
}

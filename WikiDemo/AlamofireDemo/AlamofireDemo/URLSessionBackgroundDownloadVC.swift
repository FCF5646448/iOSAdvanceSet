//
//  URLSessionBackgroundDownloadVC.swift
//  AlamofireDemo
//
//  Created by 冯才凡 on 2020/8/5.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import UIKit
import Alamofire

/// URLSession的基本使用
class URLSessionBackgroundDownloadVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}

extension URLSessionBackgroundDownloadVC {
    func upload() {
        /// 设置config
        let config = URLSessionConfiguration.default
        ///创建session
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        //根据url设置Task
        let url = URL(string: "")
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.post.rawValue
        let updata = UIImage(named: "")?.pngData()
        let upTast = session.uploadTask(with: request, from: updata) { (data, res, error) in
            if error != nil {
                //
            }else{
                print("上传完毕")
            }
        }
        //开启
        upTast.resume()
    }
    
    func download() {
        /// 设置background config
        let config = URLSessionConfiguration.background(withIdentifier: "backgroundIdentifier")
        /// session
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        /// 创建tast
        let downloadTast = session.downloadTask(with: URL(string: "")!)
        /// 开始下载
        downloadTast.resume()
    }
}

extension URLSessionBackgroundDownloadVC : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载完成")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(" bytesWritten \(bytesWritten)\n totalBytesWritten \(totalBytesWritten)\n totalBytesExpectedToWrite \(totalBytesExpectedToWrite)")
        print("下载进度: \(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite))\n")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("后台任务")
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let backgroundHandle = appDelegate.backgroundSessionCompletionHandler else { return }
                backgroundHandle()
            }
    }
}


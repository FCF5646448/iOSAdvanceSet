//
//  ViewController2.swift
//  AlamofireDemo
//
//  Created by 冯才凡 on 2020/8/5.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import UIKit

// 断点续传
class URLSessionResumeDownloadVC: UIViewController {

    var session: URLSession?
    var downloadTast: URLSessionDownloadTask?
    var partialData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension URLSessionResumeDownloadVC {
    //开始下载
    func download() {
        /// 设置background config
        let config = URLSessionConfiguration.background(withIdentifier: "backgroundIdentifier")
        /// session
        self.session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        /// 创建tast
        downloadTast = session!.downloadTask(with: URLRequest(url: URL(string: "")!))
        /// 开始下载
        downloadTast?.resume()
    }
    
    //挂起
    func onSuspend() {
        guard let tast = self.downloadTast else {
            return
        }
        tast.cancel {[weak self] (resumeData) in
            self?.partialData = resumeData
            self?.downloadTast = nil
        }
    }
    
    //恢复下载
    func onResume() {
        if self.downloadTast == nil {
            if self.partialData == nil {
                self.downloadTast = session?.downloadTask(with: URLRequest(url: URL(string: "")!))
            }else{
                self.downloadTast = session?.downloadTask(withResumeData: self.partialData!)
            }
            
            self.downloadTast!.resume()
        }
        
    }
}

//监听代理
extension URLSessionResumeDownloadVC : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载完成")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(" bytesWritten \(bytesWritten)\n totalBytesWritten \(totalBytesWritten)\n totalBytesExpectedToWrite \(totalBytesExpectedToWrite)")
        print("下载进度: \(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite))\n")
    }
}

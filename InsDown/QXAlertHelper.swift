//
//  QXAlertHelper.swift
//  InsDown
//
//  Created by qixin1106 on 2024/4/14.
//

import Foundation
import UIKit

class QXAlertHelper {
    
    static var progressView: UIProgressView?
    static var progressAlertController: UIAlertController?
    static var saveSheetController: UIAlertController?

        /// 显示进度alert
        /// - Parameter showVC: 从这个vc弹出
    static func showProgressAlertWithVC(_ showVC: UIViewController) {
        self.progressAlertController = UIAlertController(title: "Download", message: "The file is downloading...", preferredStyle: .alert)
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.progressView!.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
        self.progressAlertController!.view.addSubview(self.progressView!)
        showVC.present(self.progressAlertController!, animated: true, completion: nil)
    }
    
    
        /// 刷新进度条，传入的值为0~1.0
        /// - Parameter progress: 进度
    static func updateProgress(_ progress: Double) {
        self.progressView?.setProgress(Float(progress), animated: true)
    }
    
    
        /// 隐藏进度Alert
    static func hiddenProgressAlert() {
        self.progressAlertController?.dismiss(animated: false, completion: nil)
    }
    
    
        /// 显示保存Sheet提示
        /// - Parameter showVC: 从这个vc弹出
    static func showSaveSheet(_ showVC: UIViewController, saveCallback: @escaping (() -> Void), cancelCallback: @escaping (() -> Void)) {
        let saveAction = UIAlertAction(title: "Save👌🏻", style: .default) { action in
            
            saveCallback()
            
        }
        self.saveSheetController = UIAlertController(title: "download👌🏻", message: "Do you save to album", preferredStyle: .actionSheet)
        self.saveSheetController!.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Cancel❌", style: .cancel) { action in
            
            cancelCallback()

        }
        self.saveSheetController!.addAction(cancelAction)
        showVC.present(self.saveSheetController!, animated: true, completion: nil)

    }
    
    
        /// 显示一般提示性消息alert
        /// - Parameters:
        ///   - showVC: 从这个vc弹出
        ///   - title: 标题
        ///   - message: 内容
    static func showAlertController(showVC: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK👌🏻", style: .default)
        alertController.addAction(doneAction)
        showVC.present(alertController, animated: true, completion: nil)
    }
    
}

    //
    //  ViewController.swift
    //  InsDown
    //
    //  Created by qixin1106 on 2024/4/14.
    //


import UIKit
import WebKit

    // test url
    // https://www.instagram.com/reel/C2fKA4eqtNL/?igsh=bGJoOHhrdW9ieDQx

    // Get the src value of the video tag js script
private let findVideoSrcScript = """
        (function() {
            var video = document.querySelector('video');
            if (video) {
                return video.src;
            }
            return '';
        })();
        """

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotif()
        initWebViewUI()
    }
    
    
        /// Register for event notifications
    private func registerNotif() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
        /// Create webView
    private func initWebViewUI() {
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView?.navigationDelegate = self
        self.view.addSubview(self.webView!)
        
        self.webView?.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                self.webView!.topAnchor.constraint(equalTo: guide.topAnchor),
                self.webView!.widthAnchor.constraint(equalTo: guide.widthAnchor),
                self.webView!.heightAnchor.constraint(equalTo: guide.heightAnchor),
                self.webView!.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.webView!.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                self.webView!.widthAnchor.constraint(equalTo: view.widthAnchor),
                self.webView!.heightAnchor.constraint(equalTo: view.heightAnchor),
                self.webView!.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            self.webView?.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }

    }
    
    
        /// Adjust the layout of webview
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.webView?.frame = self.view.bounds
//    }
    
        /// Trigger to read the data in the clipboard. When the data obtained is a valid URL and the host is www.instagram.com, trigger the webview to load this URL.
    @objc private func didBecomeActiveNotification() {
        if let content = UIPasteboard.general.string {
            
            let host = URL(string: content)?.host
            guard host == "www.instagram.com" else {
                return
            }
            if let url = URL(string: content) {
                self.webView?.load(URLRequest(url: url))
            }
            UIPasteboard.general.string = nil // 清空剪贴板
        }
    }
    
    
    
        /// When the webview is loaded, trigger the js script to obtain the download URL of the video.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript(findVideoSrcScript) { (result, error) in
            
            if let result = result as? String {
                
                guard result.count > 0 else {
                    return
                }
                
                QXAlertHelper.showProgressAlertWithVC(self)
                QXVideoDownloader.videoDownload(url: result) { progress in
                    
                    QXAlertHelper.updateProgress(progress)
                    
                } downloadSuccess: { fileURL in
                    
                    debugPrint("video👌🏻:", fileURL)
                    QXAlertHelper.hiddenProgressAlert()
                    QXAlertHelper.showSaveSheet(self) {
                        
                        QXVideoSaveHelper.saveVideo(fileURL: fileURL)
                        
                    }
                }
            }
        }
    }
    
}

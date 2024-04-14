    //
    //  QXVideoDownloader.swift
    //  DownIns
    //
    //  Created by qixin1106 on 2024/04/14.
    //

import Foundation

class DownloadTaskDelegate: NSObject, URLSessionDownloadDelegate {
    
    var updateProgress: ((Double) -> Void)?
    var downloadSuccess: ((URL) -> Void)?
    
    
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.updateProgress?(progress)
        }
    }
    
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let fileManager = FileManager.default
            let destinationURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(downloadTask.originalRequest!.url!.lastPathComponent)
            if fileManager.fileExists(atPath: destinationURL.path) {
                debugPrint("The file exists")
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.moveItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.downloadSuccess?(destinationURL)
            }
        } catch {
            debugPrint("save video error: \(error)")
        }
    }
}


class QXVideoDownloader {
    
    static var sessionDelegate = DownloadTaskDelegate()
    static var downloadSession = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
    
    static func videoDownload(url: String, updateProgress: @escaping (Double) -> Void, downloadSuccess: @escaping (URL) -> Void) {
        sessionDelegate.updateProgress = updateProgress
        sessionDelegate.downloadSuccess = downloadSuccess
        guard let videoURL = URL(string: url) else { return }
        
        let downloadTask = downloadSession.downloadTask(with: videoURL)
        downloadTask.resume()
    }
}

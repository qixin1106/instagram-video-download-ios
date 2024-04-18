//
//  QXVideoSaveHelper.swift
//  InsDown
//
//  Created by qixin1106 on 2024/4/14.
//

import Foundation
import Photos

class QXVideoSaveHelper {
    
    
        /// save into the album
    static func saveVideo(fileURL: URL, finished: @escaping ((Bool) -> Void)) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { saved, error in
            if saved {
                let alertText = "save👌🏻"
                debugPrint(alertText)
            }
            finished(saved)
        }
    }
    
    /// remove cache file
    static func removeCacheVideoFile(fileURL: URL) {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            debugPrint(error)
        }
    }
}

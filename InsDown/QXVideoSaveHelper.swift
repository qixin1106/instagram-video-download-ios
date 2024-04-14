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
    static func saveVideo(fileURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { saved, error in
            if saved {
                let alertText = "save👌🏻"
                debugPrint(alertText)
            }
        }
    }
}

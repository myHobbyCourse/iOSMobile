//
//  PHPhotosExtension.swift
//  Checkin
//
//  Created by Yudiz Solutions Pvt.Ltd. on 20/05/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import Foundation
import Photos

let manager = PHImageManager.default()
let deliveryOptions = PHImageRequestOptionsDeliveryMode.opportunistic
let requestOptions = PHImageRequestOptions()

let thumbnailSize = CGSize(width: 200, height: 200)


//MARK: - Graphics
extension PHAsset {
    
    func getAssetThumbnail(_ targetSize : CGSize? = thumbnailSize) -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: thumbnailSize, contentMode: .aspectFit, options: option, resultHandler: {(image, properties)->Void in
            if let img = image{
                thumbnail = img
            }
            
        })
        return thumbnail
    }
    
    func getAssetOriginal() -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.deliveryMode = .fastFormat
        var thumbnail = UIImage(named: "media_placeholder")
        option.isSynchronous = true
        let size = CGSize(width: 640, height: 480)
        manager.requestImage(for: self, targetSize:size, contentMode:PHImageContentMode.aspectFit, options: option, resultHandler: {(image, properties)->Void in
            if let img = image{
                thumbnail = img
            }else{
                if let info = properties {
                    if let imageIsInCloud = info[PHImageResultIsInCloudKey] as? Bool {
                        if imageIsInCloud {
                            // Image is not on the disk, it is in the cloud.
                            option.isNetworkAccessAllowed = true //Allow PHImageManager to get the image from the cloud
                            manager.requestImage(for: self, targetSize:PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: option, resultHandler: {(image, properties)->Void in
                                if let img = image{
                                    thumbnail = img
                                }else{
                                    manager.requestImage(for: self, targetSize: thumbnailSize, contentMode: .aspectFit, options: option, resultHandler: {(image, properties)->Void in
                                        if let img = image{
                                            thumbnail = img
                                        }
                                    })
                                }
                            })
                            
                        }
                    }
                }
                
            }
        })
        return thumbnail
    }
    
    func getAssetOriginal1() -> UIImage{
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        //Try to get the image from local storage
        manager.requestImageData(for: self, options: option) { (data, dataUTI, orientation, userInfo) -> Void in
            if let info = userInfo {
                if let imageIsInCloud = info[PHImageResultIsInCloudKey] as? Bool {
                    if !imageIsInCloud {
                        if let d = data {
                            if let img = UIImage(data: d) {
                                thumbnail = img
                            }
                        }
                    } else {
                        // Image is not on the disk, it is in the cloud.
                        option.isNetworkAccessAllowed = true //Allow PHImageManager to get the image from the cloud
                        manager.requestImageData(for: self, options: option, resultHandler: { (imageData, imageDataUTI, imageOrientation, imageUserInfo) -> Void in
                            if let d = imageData {
                                if let img = UIImage(data: d) {
                                    thumbnail = img
                                }
                            }
                        })
                    }
                }
            }
        }
        return thumbnail
    }
    
}

//
//  ImageModel.swift
//  Image Gallery
//
//  Created by Mouhamed Sourang on 3/20/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ImageModel: NSObject, NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider = ["public.url", "public.jpeg"]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        switch typeIdentifier {
        case "public.url":
            let urlData =  try? NSKeyedArchiver.archivedData(withRootObject: url.imageURL as NSURL, requiringSecureCoding: true)
            completionHandler(urlData as Data?,nil)
        case "public.jpeg":
            let imageData = image.jpegData(compressionQuality: 1)
            completionHandler(imageData,nil)
        default:
            return nil
        }
        return nil
    }
    
    var url: URL!
    var aspectRatio: CGSize!
    var image: UIImage!
    
    override init() {
        super.init()
    }
}


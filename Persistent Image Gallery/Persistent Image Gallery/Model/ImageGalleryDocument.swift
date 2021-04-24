//
//  ImageGalleryDocument.swift
//  Persistent Image Gallery
//
//  Created by Mouhamed Sourang on 4/23/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class ImageGalleryDocument: UIDocument {
    
    var imageGallery: ImageGallery?
    
    override func contents(forType typeName: String) throws -> Any {
        return imageGallery?.data ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let contents = contents as? Data {
            imageGallery = ImageGallery(data: contents)
        }
    }
    
}

//
//  ImageModel.swift
//  Persistent Image Gallery
//
//  Created by Mouhamed Sourang on 4/23/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct ImageGallery: Codable  {
    
    var documentName = String()
    var galleryIndentifier = Int()
    var imageModels = [ImageModel]()
    
    init?(data: Data){
        if  let imageGallery = try? JSONDecoder().decode(ImageGallery.self, from: data) {
            self = imageGallery
        } else {
            return nil
        }
    }
    
    var data : Data? {
        let data = try? JSONEncoder().encode(self)
        return data
    }
    
    init() {
    }
    
}

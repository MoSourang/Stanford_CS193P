//
//  ImageCollectionViewCell.swift
//  Persistent Image Gallery
//
//  Created by Mouhamed Sourang on 4/23/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    override func awakeFromNib() {
        cellActivityIndicator.hidesWhenStopped = true
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
    
}

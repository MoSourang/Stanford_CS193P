//
//  ImageDetailViewController.swift
//  Persistent Image Gallery
//
//  Created by Mouhamed Sourang on 4/23/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    private var imageView = UIImageView()
    var imageModel : ImageModel!
    
    // legeraging the seting of an image to configure scrollview and imageview and constrict the scrollview's content size to the
    // imageview size
    private var newImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            scrollView.zoomScale = 1.0
            imageView.image = newValue
            imageView.sizeToFit()
            let size = newValue?.size
            imageView.frame = CGRect(origin: CGPoint.zero, size: size!)
            scrollView.contentSize = size!
            scrollViewHeight.constant = size!.height
            scrollViewWidth.constant = size!.width
        }
    }
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    private func performFetch() {
        fetchImage(using: imageModel.url, with: imageModel.aspectRatio) { (image) in
            DispatchQueue.main.async {
                self.newImage = image
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 0.1
        }
    }
    
    //MARK: - ScrollView Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // resize the scrollView based on the its contentSize
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
}

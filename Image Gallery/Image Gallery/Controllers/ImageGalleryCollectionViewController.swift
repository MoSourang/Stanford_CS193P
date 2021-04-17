//
//  ImageGalleryCollectionViewController.swift
//  Image Gallery
//
//  Created by Mouhamed Sourang on 3/13/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

//MARK: -  Todo Fix layout issues

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout, didDeleteImageModel {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        ImageGalleryCollectionViewController.customView.delegate = self
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(resizeCell(gesture:)))
        self.collectionView.addGestureRecognizer(pinchGesture)
        cellWidth = self.view.bounds.width / 5
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.rightBarButtonItem = imageGalleryTrash
    }
    
    // resize collectionView Cell on Zoom
    @objc func resizeCell(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            cellWidth = cellWidth * gesture.scale
            gesture.scale = 1
        }
        flowLayout?.invalidateLayout()
    }
    
    var imageGallery = ImageGalery()
    private var cellWidth: CGFloat!
    
    weak var addDelegate : ImageGalleryDidAddImage?
    weak var deleteDelegate: ImageGalleryDidDeleteImage?
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    static private var customView: TrashButtonView = {
        let customView =  TrashButtonView()
        customView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40))
        customView.sizeToFit()
        return customView
    }()
    
    private var imageGalleryTrash: UIBarButtonItem =  {
        let barItem = UIBarButtonItem(customView: customView)
        let trashDropInteraction = UIDropInteraction(delegate: barItem.customView as! UIDropInteractionDelegate)
        barItem.customView?.addInteraction(trashDropInteraction)
        barItem.tintColor = .clear
        return barItem
    }()
    
    //MARK: - DataSource & Layout Delegates
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery.imageModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        guard let imageCell = cell as? ImageCollectionViewCell else {fatalError()}
        imageCell.imageView.image = nil
        imageCell.imageView.setNeedsDisplay()
        imageCell.cellActivityIndicator.startAnimating()
        let imageModel = imageGallery.imageModels[indexPath.item]
        fetchImage(using: imageModel.url, with: imageModel.aspectRatio) { (image) in
            DispatchQueue.main.async {
                imageCell.imageView.image = image
                imageCell.cellActivityIndicator.stopAnimating()
            }
        }
        return cell
    }
    
    // return cell size on zoom while preventing cell size to exceed the collectionview's cell width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellWidth > self.view.bounds.width { cellWidth = self.view.bounds.width }
        let width = CGFloat(cellWidth)
        let height = calculateNewHeight(using: imageGallery.imageModels[indexPath.item].aspectRatio.width, for:  imageGallery.imageModels[indexPath.item].aspectRatio.height)
        return CGSize(width: width, height: height)
    }
    
    // Calculates new size for the image while maintaining the aspect ratio
    private func calculateNewHeight(using width: CGFloat, for height: CGFloat) -> CGFloat  {
        let scalefactor = cellWidth / width
        let newHeight = height * scalefactor
        return newHeight
    }
    
    // Seguing to a new view controller where the images is to be do displayed in full
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
        let imageModel = imageGallery.imageModels[indexPath!.item]
        if let imageDVC = segue.destination as? ImageDetailViewController {
            imageDVC.imageModel = imageModel
        }
    }
    
    //MARK: - CollectionView Drag Delegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            session.localContext = collectionView
            return dragedItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        session.localContext = collectionView
        return dragedItem(at: indexPath)
    }
    
    func dragedItem(at indexPath: IndexPath ) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageGallery.imageModels[indexPath.item]))
        dragItem.localObject = imageGallery.imageModels[indexPath.item]
        return [dragItem]
    }
    
    //MARK: - CollectionView Drop Delegete
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        if isSelf {
            return session.canLoadObjects(ofClass: UIImage.self)
        } else {
            return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator){
        let destinationIndexPath = coordinator.destinationIndexPath ??  IndexPath(item: imageGallery.imageModels.count, section: 0)
        for item in coordinator.items {
            // handles instances where there is an internal drag from the collection View
            if let sourceIndexPath = item.sourceIndexPath {
                let imageModel = item.dragItem.localObject as! ImageModel
                guard destinationIndexPath.item < imageGallery.imageModels.count else {return}
                collectionView.performBatchUpdates({
                    self.imageGallery.imageModels.remove(at: sourceIndexPath.item)
                    self.imageGallery.imageModels.insert(imageModel, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
            } else {
                // creating a local image model instance
                let imageModel = ImageModel()
                // handle instances where there is a external drag
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "PlaceHolderCell"))
                let itemProvider = item.dragItem.itemProvider.copy() as! NSItemProvider
                //loading image object
                itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    guard error == nil else {return}
                    guard let image = provider as? UIImage else {return}
                    imageModel.aspectRatio = image.size
                    imageModel.image = image
                    // loading url object
                    itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                        guard error == nil else {return}
                        guard let url = provider as? URL else {return}
                        imageModel.url = url.imageURL
                        // saving image and url object in my local model
                        DispatchQueue.main.async {
                            placeholderContext.commitInsertion { (insertionIndexPath) in
                                self.imageGallery.imageModels.insert(imageModel, at: insertionIndexPath.item)
                                self.addDelegate?.saveModel(for: imageModel, at: self.imageGallery.galleryIndentifier)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Custom Delegate Methods to handle image deletion
extension ImageGalleryCollectionViewController {
    func deleteImage(for imageModel: ImageModel) {
        guard let IndexOfimageModel = imageGallery.imageModels.firstIndex(of: imageModel) else {return}
        collectionView.performBatchUpdates({
            imageGallery.imageModels.remove(at: IndexOfimageModel)
            collectionView.deleteItems(at: [IndexPath(item: IndexOfimageModel, section: 0)])
        })
        UIView.animate(withDuration: 0.5, animations: {
            ImageGalleryCollectionViewController.customView.alpha = 0
        }) { (done) in
            ImageGalleryCollectionViewController.customView.alpha = 1
        }
        deleteDelegate?.deleteModel(for: imageModel, at: imageGallery.galleryIndentifier)
    }
}

//MARK: - Helper Functions
extension UIViewController {
    // Fetches the images using the provided URL
    func fetchImage(using url: URL , with aspectRatio: CGSize, completion: @escaping (_ image : UIImage) -> Void) {
        var image: UIImage!
        
        // create a URL session
        let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = 120
            return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        }()
        
        let task = session.dataTask(with: url.imageURL) { (data, response, error) in
            // add placeholder image if error is return from the request
            if let _ = error {
                let noImage = UIImage(named: "noImage")
                completion(noImage!)
            }
            if let data = data {
                image = UIImage(data: data)
                // image was found
                if image != nil {
                    completion(image)
                } else {
                    // image was not found
                    let noImage = UIImage(named: "noImage")
                   completion(noImage!)
                }
            }
        } ; task.resume()
    }
}

// Notifies the delegate that an image has been added to the collectionview
protocol ImageGalleryDidAddImage: AnyObject  {
    func saveModel (for imageModel: ImageModel, at index: Int)
}
// Notifies the delegate that an image has been deleted to the collectionview
protocol ImageGalleryDidDeleteImage: AnyObject  {
    func deleteModel (for imageModel: ImageModel, at index: Int)
}

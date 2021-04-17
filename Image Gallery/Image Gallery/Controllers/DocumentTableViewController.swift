//
//  DocumentTableViewController.swift
//  Image Gallery
//
//  Created by Mouhamed Sourang on 3/13/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class DocumentTableViewController: UITableViewController, cellTextDidUpdate, ImageGalleryDidAddImage, ImageGalleryDidDeleteImage {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var imageGalleries = [ImageGalery]()
    private var recentlyDeletedimageGalleries = [ImageGalery]()
    
    override func viewWillLayoutSubviews() {
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let imageGallery = ImageGalery(documentName: "Untitled".madeUnique(withRespectTo: currentDocumentNames))
        imageGalleries.append(imageGallery)
        let indexPath = IndexPath(item: (imageGalleries.count - 1) , section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    private var currentDocumentNames: [String] {
        var documentName = [String]()
        imageGalleries.forEach { imageGal in documentName.append(imageGal.documentName)}
        return documentName
    }
    
    //MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return imageGalleries.count
        case 1:
            return recentlyDeletedimageGalleries.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageTableViewCell", for: indexPath)
        if let documentCell = cell as? DocumentTableViewCell {
            switch indexPath.section {
            case 0:
                documentCell.delegate = self
                documentCell.documentName.text = imageGalleries[indexPath.row].documentName
                documentCell.documentName.tag = indexPath.section
                imageGalleries[indexPath.row].galleryIndentifier = indexPath.row
            case 1:
                documentCell.delegate = self
                documentCell.documentName.text = recentlyDeletedimageGalleries[indexPath.row].documentName
                recentlyDeletedimageGalleries[indexPath.row].galleryIndentifier = indexPath.row
                documentCell.documentName.tag = indexPath.section
                documentCell.documentName.isUserInteractionEnabled = false
            default: break
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Image Gallery"
        case 1:
            return "Recently Deleted"
        default: return ""
        }
    }
    
    // var to store references to the destination VC and cell that triggered segue in order to proprely handle conditional segues
    private var seguedToImageGalleryCollectionViewController: ImageGalleryCollectionViewController?
    private var cellThatTriggeredSegue: DocumentTableViewCell?
    
    //MARK: - TableView Delegates 
    
    // Handling instances where the user deletes a cell and we either have to move it to the recently delete section or delete it
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.performBatchUpdates({
                recentlyDeletedimageGalleries.insert(imageGalleries.remove(at: indexPath.row), at: 0)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
            })
        case 1:
            tableView.performBatchUpdates({
                recentlyDeletedimageGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
        default: break
            
        }
    }
    
    // handling user action of undeleting a document from the recently deleted section
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // handle leading swipe from recently deleted document
        if indexPath.section == 1   {
            let newIndexPath = IndexPath(item: imageGalleries.count , section: 0)
            let documentName = recentlyDeletedimageGalleries[indexPath.row]
            let deleteContextualAction =  UIContextualAction(style: .normal, title: "Recover") { (action, view
                , completion) in
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                    self.imageGalleries.insert(documentName, at: newIndexPath.row)
                    self.recentlyDeletedimageGalleries.remove(at: indexPath.row)
                    tableView.reloadSections([1], with: .automatic)
                }) { (complete) in
                    completion(true)
                }
            }
            
            deleteContextualAction.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [deleteContextualAction])
            // no action taken for leading swipe from the image gallery
        } else {
            return nil
        }
    }
    
    // Conditionaly handly segue triggred by users to prevent :
    // - creating a new VC when the a taps happends on a document cell with an already open Image gallery
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let section = tableView.indexPath(for: (sender as! DocumentTableViewCell))?.section
        if seguedToImageGalleryCollectionViewController == nil && section == 0  {
            return true
        } else if (sender as? DocumentTableViewCell) != cellThatTriggeredSegue && section == 0  {
            return true
        } else {
            return false
        }
    }
    
    // storing references to the destination VC and cell that triggered segue in order to proprely handle conditional segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageGalVC = segue.destination as? UINavigationController, let senderCell = sender as? DocumentTableViewCell  {
            imageGalVC.navigationBar.topItem?.title = senderCell.documentName.text
            guard let indexPathForCell = tableView.indexPath(for: senderCell) else {return}
            seguedToImageGalleryCollectionViewController = (imageGalVC.children.first as! ImageGalleryCollectionViewController)
            seguedToImageGalleryCollectionViewController?.imageGallery = imageGalleries[indexPathForCell.row]
            cellThatTriggeredSegue = senderCell
            seguedToImageGalleryCollectionViewController?.addDelegate = self
            seguedToImageGalleryCollectionViewController?.deleteDelegate = self
        }
    }
}

//MARK: - Delegate Methods
extension DocumentTableViewController {
    
    // Update image gallery model when an image is added from the collectionView
    func saveModel(for imageModel: ImageModel, at index: Int) {
        imageGalleries[index].imageModels.append(imageModel)
    }
    
    // Delete image gallery model when an image is delete from the collectionView
    func deleteModel(for imageModel: ImageModel, at index: Int) {
        guard let modelIndex = imageGalleries[index].imageModels.firstIndex(of: imageModel) else {return}
        imageGalleries[index].imageModels.remove(at: modelIndex)
      }
      
    // Update name of image gallery
    func updateTextForCell(using newName: String, for documentCell: DocumentTableViewCell) {
        if let cellRow = tableView.indexPath(for: documentCell)?.row , let cellText = documentCell.documentName.text {
            imageGalleries[cellRow].documentName = cellText
        }
    }
}




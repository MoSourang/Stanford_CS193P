//
//  DocumentBrowserViewController.swift
//  Persistent Image Gallery
//
//  Created by Mouhamed Sourang on 4/23/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        createTemplate()
    }
    
    var template: URL?
    
    func createTemplate() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            allowsDocumentCreation = true
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent("Untiltled.json")
            if template != nil {
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
            }
        }
        
    }
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    func presentDocument(at documentURL: URL) {
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let ImageGalleryNavController =  storyBoard.instantiateViewController(identifier: "ImageGalleryNavController") as? UINavigationController else {return}
        
        
        if let imageGalleryCollectionViewController  = ImageGalleryNavController.contents as? ImageGalleryCollectionViewController {
            imageGalleryCollectionViewController.document = ImageGalleryDocument(fileURL: documentURL)
        }
        
        ImageGalleryNavController.modalPresentationStyle = .fullScreen
        self.present(ImageGalleryNavController, animated: true)
    }
}


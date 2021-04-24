//
//  TrashButtonView.swift
//  Persistent Image Gallery
//
//  Created by Mouhamed Sourang on 4/23/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class TrashButtonView: UIView, UIDropInteractionDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    weak var delegate: didDeleteImageModel?
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropProposal = UIDropProposal(operation: .copy)
        return dropProposal
    }
    
    override func draw(_ rect: CGRect) {
        if let trashImage = UIImage(named: "trash", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
            trashImage.draw(in: bounds)
            trashImage.withRenderingMode(.alwaysTemplate)
            trashImage.withTintColor(.clear)
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let data = session.items.first?.localObject as! (ImageModel, Int)
        delegate?.deleteImage(for: data.0, at: data.1)
    }
}

// Notifies the delegate that an images has been added to the trash
protocol didDeleteImageModel: AnyObject {
    func deleteImage(for imageModel: ImageModel, at modelIndex:Int)
}

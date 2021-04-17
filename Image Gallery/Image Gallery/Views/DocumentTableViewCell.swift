//
//  ImageTableViewCell.swift
//  Image Gallery
//
//  Created by Mouhamed Sourang on 4/7/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(activateCellEditing(gesture:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.delegate = self
        documentName.superview?.addGestureRecognizer(doubleTapGestureRecognizer)
        documentName.isUserInteractionEnabled = false
        documentName.delegate = self
    }
    
    @IBOutlet weak var documentName: UITextField!
    weak var delegate : cellTextDidUpdate?
    
    @objc func activateCellEditing(gesture: UITapGestureRecognizer) {
        if documentName.tag == 0 { documentName.isUserInteractionEnabled = true }
    }
    
    //MARK: - Textfield Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate!.updateTextForCell(using: textField.text!, for : self)
        documentName.isUserInteractionEnabled = false
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// protocol for notifiying tableview that document name has been updated
protocol cellTextDidUpdate: AnyObject {
    func updateTextForCell(using newName: String, for documentCell: DocumentTableViewCell)
}

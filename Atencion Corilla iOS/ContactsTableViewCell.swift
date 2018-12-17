//
//  ContactsTableViewCell.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 11/25/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase

protocol ContactsTableViewCellDelegate {
    func tappedMessage(name: String)
    func tappedDelete(name: String)
}

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var compaLabel: UILabel!
    @IBOutlet weak var sendMessage: UIImageView!
    @IBOutlet weak var MessageCompaButton: UIButton!
    @IBOutlet weak var deleteCompa: UIImageView!
    @IBOutlet weak var DeleteCompaButton: UIButton!
    
    var delegate: ContactsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func MessageCompaButtonTouched(_ sender: Any) {
//        print("MessageCompaButtonTouched")
        delegate?.tappedMessage(name: compaLabel.text!)
        }
    
    @IBAction func DeleteCompaButtonTouched(_ sender: Any) {
//        print("DeleteCompaButtonTouched")
        delegate?.tappedDelete(name: compaLabel.text!)
        
    }
    
    
}


//
//  SolicitudesTableViewCell.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 12/13/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase

protocol SolicitudesTableViewCellDelegate {
    func tappedAdd(name: String)
    func tappedRemove(name: String)
}

class SolicitudesTableViewCell: UITableViewCell {

    @IBOutlet weak var solicitudLabel: UILabel!
    @IBOutlet weak var add: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var delete: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: SolicitudesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func AddButtonTouched(_ sender: Any) {
                print("AddButtonTouched")
        delegate?.tappedAdd(name: solicitudLabel.text!)
    }
    
    @IBAction func DeleteButtonTouched(_ sender: Any) {
                print("DeleteButtonTouched")
        delegate?.tappedRemove(name: solicitudLabel.text!)
    }
}

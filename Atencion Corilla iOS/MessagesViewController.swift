//
//  MessagesViewController.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 12/12/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase

class MessagesViewController: BaseViewController, ContactsViewControllerDelegate{
    
//    var sendTo : String!
//    var sendFrom : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func messageToFrom(to: String, from: String) {
        let sendTo = to
        let sendFrom = from
        print("MessagesViewController")
        print("from \(sendFrom) to \(sendTo)")
        
    }
    
    


    
}

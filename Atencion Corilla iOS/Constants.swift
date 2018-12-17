//
//  Constants.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 12/2/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}

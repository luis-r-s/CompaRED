//
//  DataServices.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 12/2/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import KeychainSwift

let DB_BASE = Database.database().reference()

class DataService {
    private var _keyChain = KeychainSwift()
    private var _refDatabase = DB_BASE
    
    var keyChain: KeychainSwift {
        get {
            return _keyChain
        } set {
            _keyChain = newValue
        }
    }
}

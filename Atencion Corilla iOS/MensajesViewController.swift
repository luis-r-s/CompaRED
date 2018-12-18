////
////  MessagesViewController.swift
////  Atencion Corilla iOS
////
////  Created by Maria del Carmen Ramos Alamo on 12/12/18.
////  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
////
//
//import UIKit
//import Firebase
//import CoreData
//import FirebaseDatabase
//
//class MessajesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{
//    
//    
//    var mensajes = [String]()
//    
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mensajes.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "mensajeCell", for: indexPath) as! MessagesTableViewCell
//        cell.mensajeLabel.text = mensajes[indexPath.row]
//        return cell
//    }
//    
//    func fetchMensajes() {
//        mensajes = []
//        if let currentUser = Auth.auth().currentUser{
//            Database.database().reference().child("mensajes").child(currentUser.displayName!).observe(.childAdded, with: { (snapshot) in
//                
//                print("snapshot = ", snapshot)
//                print("friend = ", snapshot.key)
//                self.mensajes.append(snapshot.key)
//                self.tableView.reloadData()
//                
//            }, withCancel: nil)
//        }
//    }
//    
//    
//    
//}

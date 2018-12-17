//
//  CompasViewController.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 11/25/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase

//protocol ContactsViewControllerDelegate{
//    func messageToFrom(to: String, from: String)
//}

class ContactsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ContactsTableViewCellDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    var friends = [String]()
    
    //    var delegate: ContactsViewControllerDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "compaCell", for: indexPath) as! ContactsTableViewCell
        cell.compaLabel.text = friends[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        fetchContacts()
        
    }
    
    func fetchContacts() {
        friends = []
        if let currentUser = Auth.auth().currentUser{
            Database.database().reference().child("contacts").child(currentUser.displayName!).observe(.childAdded, with: { (snapshot) in
                
                print("snapshot = ", snapshot)
                print("friend = ", snapshot.key)
                print("value = ", snapshot.value as! Bool)
                
                if snapshot.value as! Bool{
                    self.friends.append(snapshot.key)
                    self.tableView.reloadData()
                }
                
            }, withCancel: nil)
        }
    }
    
    
    
    func tappedMessage(name: String) {
        print("Message \(name)")
        let sender = Auth.auth().currentUser!.displayName!
        //        let other = name
        //        delegate?.messageToFrom(to: other, from: sender)
        //        print("to: \(other) from: \(sender)")
        
        let dialog = UIAlertController(title: "Mensaje Nuevo para \(name)", message: "Escribir mensaje", preferredStyle: .alert)
        
        dialog.addTextField()
        dialog.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        let addAction = UIAlertAction(title: "Enviar", style: .default) {
            [unowned self] action in
            
            if let mensaje = dialog.textFields?.first?.text {
                print(mensaje)
                let ref = Database.database().reference()
                let refMensajes = ref.child("mensajes").child(name)
                refMensajes.childByAutoId().setValue("\(sender): \(mensaje)")
                
            }
        }
        
        dialog.addAction(addAction)
        
        present(dialog, animated: true)
        
        
    }
    
    
    func tappedDelete(name: String) {
        print("Delete \(name)")
        if let currentUser = Auth.auth().currentUser{
            let ref = Database.database().reference().child("contacts").child(currentUser.displayName!)
            ref.child(name).removeValue()
            fetchContacts()
        }
    }
}


//extension ContactsViewController: ContactsTableViewCellDelegate {
//
//
//
//}

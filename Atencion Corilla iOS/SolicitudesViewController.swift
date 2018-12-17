//
//  SolicitudesViewController.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 12/13/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase

class SolicitudesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SolicitudesTableViewCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var solicitudLabel: UITextField!
    @IBOutlet var solicitud: UIButton!
    
    var solicitudes = [String]()
    var array = [String]()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solicitudes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "solicitudCell", for: indexPath) as! SolicitudesTableViewCell
        cell.solicitudLabel.text = solicitudes[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        fetchSolicitudes()
        fetchUsers()

    }
    
    func fetchSolicitudes() {
        solicitudes = []
        if let currentUser = Auth.auth().currentUser{
            Database.database().reference().child("solicitudes").child(currentUser.displayName!).observe(.childAdded, with: { (snapshot) in
                
                print("snapshot = ", snapshot)
                print("friend = ", snapshot.key)
                print("value = ", snapshot.value as! Bool)
                
                if snapshot.value as! Bool{
                    self.solicitudes.append(snapshot.key)
                    self.tableView.reloadData()
                }
                
            }, withCancel: nil)
        }
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print("snapshot.key = ", snapshot.key)
            self.array.append(snapshot.key)
            print("array: \(self.array)")
        }, withCancel: nil)
    }
    
    func tappedAdd(name: String) {
        print("Add \(name)")
        
        if let currentUser = Auth.auth().currentUser{
            let ref = Database.database().reference().child("solicitudes").child(currentUser.displayName!)
            ref.child(name).removeValue()
            
            fetchSolicitudes()
            
            let ref2 = Database.database().reference().child("contacts").child(currentUser.displayName!)
            ref2.child(name).setValue(true)
            
            let ref3 = Database.database().reference().child("contacts").child(name)
            ref3.child(currentUser.displayName!).setValue(true)
            
            fetchSolicitudes()
        }
        
    }
    

    
    @IBAction func enviarSolicitud(_ sender: Any) {
        print("enviarSolicitud")
        
        if let currentUser = Auth.auth().currentUser{
            let contact = solicitudLabel.text
 
            if  contact == currentUser.displayName!{
                AlertController.showAlert(self, title: "Error", message: "No te puedes añadir a ti mismo.")
                return
            } else {
                if contact == "" {
                    } else {
                    if self.array.contains(contact!){
                        print("\(contact!) exite")
                        let refSol = Database.database().reference().child("solicitudes").child(contact!)
                        refSol.child(currentUser.displayName!).setValue(true)
                        return
                    } else {
                        print("\(contact!) no exite")
                        return
                    }
                }
            }
        }
    }
    
    func tappedRemove(name: String) {
        print("Delete \(name)")
        if let currentUser = Auth.auth().currentUser{
            let ref = Database.database().reference().child("solicitudes").child(currentUser.displayName!)
            ref.child(name).removeValue()
            fetchSolicitudes()
        }
    }

    
}

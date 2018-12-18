//
//  ViewController.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 10/21/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import KeychainSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var AlreadyAccountButton: UIButton!
    
    var array = [String]()
    var arrayEmails = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        fetchEmails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func AlreadyAccountTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToLogIn", sender: self)
    }
    
    
    
    @IBAction func RegisterTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
            username != "" else {
                AlertController.showAlert(self, title: "Falta información", message: "Favor de llenar todos los espacios")
                return
        }
        
        if self.array.contains(username){
            AlertController.showAlert(self, title: "Nombre de usuario no disponible", message: "Favor de escoger otro nombre de usuario")
            return
        }
        
        guard let email = EmailTextField.text,
            email != "" else {
                AlertController.showAlert(self, title: "Falta información", message: "Favor de llenar todos los espacios")
                return
        }
        
        if self.arrayEmails.contains(email){
            AlertController.showAlert(self, title: "Correo Electrónico no disponible", message: "Favor de escoger otro correo electrónico")
            return
        }
        
        guard let password = PasswordTextField.text,
            password != "" else {
                AlertController.showAlert(self, title: "Falta información", message: "Favor de llenar todos los espacios")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            guard let u = Auth.auth().currentUser else { return }
            print(u.email ?? "MISSING EMAIL")
            print(u.uid)
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "GoToHome", sender: nil)
                
                guard let uid = user?.user.uid else {
                    return
                }
                
                let ref = Database.database().reference(fromURL: "https://atencioncorilla.firebaseio.com/")
                let usersReference = ref.child("users").child(username)
                let values = ["uid" : uid, "email" : email]
                print(ref.child("users"))
                
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print(err)
                        return
                    }
                    else {
                        print(usersReference)
                    }
                })
            })
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // Dismiss the keyboard when the view is tapped on
        usernameTextField.resignFirstResponder()
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print("snapshot.key = ", snapshot.key)
            self.array.append(snapshot.key)
            print("array: \(self.array)")
        }, withCancel: nil)
    }
    
    func fetchEmails() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            print("value = \(email)")
            self.arrayEmails.append(email)
            print("array: \(self.arrayEmails)")
        }, withCancel: nil)
    }
}

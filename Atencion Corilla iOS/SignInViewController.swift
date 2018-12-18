//
//  SignIn.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 10/27/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import KeychainSwift

class SignInViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var BackRegistrationButton: UIButton!
    
    var arrayEmails = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmails()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func SignInTapped(_ sender: Any) {
        
        guard let email = EmailTextField.text,
            email != "" else {
                AlertController.showAlert(self, title: "Falta información", message: "Favor de llenar todos los espacios")
                return
        }
        guard let password = PasswordTextField.text,
            password != "" else {
                AlertController.showAlert(self, title: "Falta información", message: "Favor de llenar todos los espacios")
                return
        }
        if self.arrayEmails.contains(email){
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print("EROR")
                    AlertController.showAlert(self, title: "Error", message: error.localizedDescription)
                    return
                } else {
                    guard let u = Auth.auth().currentUser else { return }
                    print(u.email ?? "MISSING EMAIL")
                    print(u.displayName ?? "MISSING DISPLAY NAME")
                    print(u.uid)
                    
                    self.performSegue(withIdentifier: "GoToHome2", sender: nil)
                }
            })
        } else{
            AlertController.showAlert(self, title: "Información Incorrecta", message: "Favor de intentar nuevamente.")
            return
        }
    }

    
    @IBAction func BackRegistrationTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToRegister", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // Dismiss the keyboard when the view is tapped on
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
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

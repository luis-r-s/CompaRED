//
//  MenuViewController.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 10/29/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MapKit
import CoreLocation

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    
    var locationManager = CLLocationManager()
    var currentLocation : String!
    
    @IBOutlet weak var Mapa: UIButton!
    @IBOutlet weak var Contactos: UIButton!
    @IBOutlet weak var Mensajes: UIButton!
    @IBOutlet weak var Salir: UIButton!
    @IBOutlet weak var Panic: UIButton!
    @IBOutlet weak var Escribir: UIButton!
    @IBOutlet weak var Solicitudes: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentLocation = "(\(locValue.latitude), \(locValue.longitude))"
        print(self.currentLocation as String)
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        btnMenu.tag = 0
        btnMenu.isHidden = false
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    @IBAction func MapaButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showMapa", sender: self)
    }
    
    @IBAction func EscribirButtonTapped(_ sender: Any) {
        let dialog = UIAlertController(title: "Mensaje Nuevo", message: "Escribir mensaje", preferredStyle: .alert)
        
        dialog.addTextField()
        dialog.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        let addAction = UIAlertAction(title: "Enviar", style: .default) {
            [unowned self] action in
            
            if let mensaje = dialog.textFields?.first?.text {
                print(mensaje)
                let ref = Database.database().reference()
                let currentUser = Auth.auth().currentUser!.displayName!
                let refContacts = ref.child("contacts").child(currentUser)
                let refMensajes = ref.child("mensajes")
                
                refContacts.observe(.childAdded, with: { (snapshot) in
                    if snapshot.value as! Bool{
                        print("\(snapshot.key):\(mensaje)")
                        refMensajes.child("\(snapshot.key)").childByAutoId().setValue("\(currentUser): \(mensaje)")
                    }
                }, withCancel: nil)
            }
        }
        
        dialog.addAction(addAction)
        
        present(dialog, animated: true)
    }
    
    @IBAction func ContactsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showContactos", sender: self)
    }
    
    @IBAction func MensajesButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showMensajes", sender: self)
    }
    
    @IBAction func SalirButtonTapped(_ sender: Any) {
        print("SalirButtonTapped")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Successfully sign out")
//                        dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "salir", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
        
    }
    
    @IBAction func SolicitudesButtonTapped(_ sender: Any){
        performSegue(withIdentifier: "showSolicitudes", sender: self)
    }
    
    @IBAction func PanicButtonTapped(_ sender: Any)  {
        
        //        guard let locValue: CLLocationCoordinate2D = CLLocationManager.location!.coordinate else { return }
        
        let dialog = UIAlertController(title: "Alerta de Pánico", message: "Confirmar alerta", preferredStyle: .alert)
        
        //        dialog.addTextField()
        dialog.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        let addAction = UIAlertAction(title: "Enviar", style: .default) {
            [unowned self] action in
            
            let ref = Database.database().reference()
            let currentUser = Auth.auth().currentUser!.displayName!
            let refContacts = ref.child("contacts").child(currentUser)
            let refMensajes = ref.child("mensajes")
            //                let currentLocation =
                
            refContacts.observe(.childAdded, with: { (snapshot) in
                if snapshot.value as! Bool{
                    print("enviando mensaje de pánico a \(snapshot.key)")
                    refMensajes.child("\(snapshot.key)").childByAutoId().setValue("\(currentUser): PÁNICO @ lat/lng: \(self.currentLocation ?? "")")
                }
            }, withCancel: nil)
        }
    
        dialog.addAction(addAction)
        
        present(dialog, animated: true)
    }
    
    
}

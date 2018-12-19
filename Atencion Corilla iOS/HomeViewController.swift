//
//  HomeViewController.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 10/22/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class HomeViewController: BaseViewController {
    //Map
    @IBOutlet weak var mapView: MKMapView!
    
    var filter = [true    , true    , true       , true]
    let type   = ["Acoso" , "Asalto", "Violacion", "Otro"]
    let color  = [0xff0000, 0x007fff, 0x00ffff   , 0x00ff00]
    
    let locationManager = CLLocationManager()
    let regionSizeInMeters : Double = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        showReports()
        checkLocationServices()
    }
    @IBAction func refresh(_ sender: Any) {
        showReports()
    }
    
    @IBAction func unwindHome(_ sender: UIStoryboardSegue) {}
    
    @IBAction func setPin(_ sender: UILongPressGestureRecognizer) {
        for annotation in mapView.annotations {
            if (annotation.title == "Report Pin") {
                self.mapView.removeAnnotation(annotation)
            }
        }
        let location = sender.location(in: self.mapView)
        let coordinates = self.mapView.convert(location, toCoordinateFrom: mapView)
        let reportPin = MKPointAnnotation()
        
        reportPin.coordinate = coordinates
        reportPin.title      = "Report Pin"
        reportPin.subtitle   = "Donde se reprota un incidente"
        
        self.mapView.addAnnotation(reportPin)
    }
    
    @IBAction func Centralizar(_ sender: Any) {
        centerViewOnUserLocation()
    }
    
    
    func showReports() {
        //database reference
        let ref = Database.database().reference(fromURL: "https://atencioncorilla.firebaseio.com/")
        let refPins = ref.child("Pins")
        
        refPins.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                let Annotations = self.mapView.annotations
                self.mapView.removeAnnotations(Annotations) //clear map pins for refresh
                
                //iterating through all the values
                for Pin in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let Object = Pin.value as? [String: AnyObject]
                    let cat  = Object?["category"]
                    let latitude = Object?["latitude"]
                    let longitude = Object?["longitude"]
                    
                    //filtering bool expresion to know wether or not to put in map
                    var onMap : Bool = false
                    for i in 0...3{
                        if(cat as! String == self.type[i] && self.filter[i] == true){
                            onMap = true
                        }
                    }
                    
                    //checks if filter will allow the pin on screen
                    if (onMap){
                    
                    //creating annotation with info from DB
                        let annotation = MKPointAnnotation()
                        annotation.title = cat as? String
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    
                    //put annotation in mapView
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
        
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionSizeInMeters, longitudinalMeters: regionSizeInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            
            break
        case .denied:
            //show alert asking for permission to use again
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //ie parental control
            break
        case .authorizedAlways:
            
            break
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        
        if segue.identifier == "ReportFormSegue" {
            var reportPin : MKAnnotation?
            for annotation in mapView.annotations {
                if (annotation.title == "Report Pin") {
                    reportPin = annotation
                }
            }
            let destinationVC = segue.destination as? ReportForm
            destinationVC?.reportPin = reportPin
        }else{
            let destinationF  = segue.destination as? FilterSelector
            destinationF?.filter = filter
        }
    
    }

}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else{return}
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionSizeInMeters, longitudinalMeters: regionSizeInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
    
}


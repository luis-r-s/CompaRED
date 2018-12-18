//
//  ReportForm.swift
//  Atencion Corilla iOS
//
//  Created by Luis Armando Rivera Sanabria on 12/3/18.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class ReportForm: UIViewController {
    
    var reportPin : MKAnnotation?
    
    let category = ["Acoso", "Asalto", "Violacion", "Otro"]
    
    @IBOutlet weak var incidentType: UISegmentedControl!
    @IBOutlet weak var timeDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Do any additional setup after loading the view.
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        if reportPin != nil {
            let ref = Database.database().reference(fromURL: "https://atencioncorilla.firebaseio.com/")
            let refPin = ref.child("Pins")
            let key = refPin.childByAutoId().key
            
            //getting date time components split
            let date = self.timeDate.date
            let calendar = Calendar.current
            let dayInt       = calendar.component(.day, from: date)
            let hourString   = String(calendar.component(.hour, from:date))
            let minuteString = String(calendar.component(.minute, from:date))
            let monthInt     = calendar.component(.month, from:date)
            let yearInt      = calendar.component(.year, from:date)
            
            
                let pin = [ "id"       : key as Any ,
                            "category" : category[incidentType.selectedSegmentIndex],
                            "day"      : dayInt,
                            "hour"     : hourString,
                            "latitude" : Double((reportPin?.coordinate.latitude)!),
                            "longitude": Double((reportPin?.coordinate.longitude)!),
                            "minute"   : minuteString,
                            "month"    : monthInt,
                            "year"     : yearInt
                    ] as [String : Any]
            refPin.child(key ?? "").setValue(pin)
            
        }
    }
    
    
    
    /*
     //MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

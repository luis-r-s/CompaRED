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
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: self.timeDate.date)
            if let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute {
                let dayInt = Int(day)
                let monthInt = Int(month)
                let yearInt = Int(year)
                let hourString = String(hour)
                let minuteString = String(minute)
            
            let pin = [ "id"       : key,
                        "category" : category[incidentType.selectedSegmentIndex],
                        "day"      : components.day,
                        "hour"     : components.hour,
                        "latitude" : reportPin?.coordinate.latitude,
                        "longitude": reportPin?.coordinate.longitude,
                        "minute"   : components.minute,
                        "month"    : components.month,
                        "year"     : components.year
                ]
            refPin.child(key ?? "").setValue(pin)
            }
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

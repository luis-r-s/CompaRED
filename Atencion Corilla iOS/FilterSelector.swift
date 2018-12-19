//
//  FilterSelector.swift
//  Atencion Corilla iOS
//
//  Created by Luis Armando Rivera Sanabria on 12/4/18.
//

import UIKit

class FilterSelector: UIViewController {
    
    var filter = [false, //Acoso
                  false, //Asalto
                  false, //Violacion
                  false  //Otro
    ]
    
    @IBOutlet weak var type_1: UISwitch!
    @IBOutlet weak var type_2: UISwitch!
    @IBOutlet weak var type_3: UISwitch!
    @IBOutlet weak var type_4: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type_1.setOn(filter[0], animated: true)
        type_2.setOn(filter[1], animated: true)
        type_3.setOn(filter[2], animated: true)
        type_3.setOn(filter[3], animated: true)
// Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! HomeViewController
        destination.filter[0] = type_1.isOn
        destination.filter[1] = type_2.isOn
        destination.filter[2] = type_3.isOn
        destination.filter[3] = type_4.isOn
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

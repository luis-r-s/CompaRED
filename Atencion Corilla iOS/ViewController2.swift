//
//  ViewController2.swift
//  Atencion Corilla iOS
//
//  Created by Maria del Carmen Ramos Alamo on 10/22/18.
//  Copyright © 2018 Maria del Carmen Ramos Alamo. All rights reserved.
//

import UIKit

class Home: UIViewController {

    
    @IBOutlet weak var ViewContactsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ViewContactsTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToContacts", sender: self)
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

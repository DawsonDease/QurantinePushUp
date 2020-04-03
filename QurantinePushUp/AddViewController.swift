//
//  AddViewController.swift
//  QurantinePushUp
//
//  Created by Dawson on 2020-03-31.
//  Copyright © 2020 Dawson. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var pushupsText: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    
    
    var data = [Entry]()
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    
    @IBAction func Submit(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
         
        let date = self.date.date
         
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
         
        data.insert(Entry(date: dateFormatter.string(from: date), pushUps: Int(pushupsText.text ?? "0" ) ?? 0 ),at: 0)
    }
    
}

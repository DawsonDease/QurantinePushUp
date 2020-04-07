//
//  HistoryViewController.swift
//  QurantinePushUp
//
//  Created by Dawson on 2020-04-01.
//  Copyright © 2020 Dawson. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Table: UITableView!
    var data = [Entry]()
    var deleted = [Entry]()
    var row = 0
    
    override func viewDidLoad() {
           super.viewDidLoad()
           Table.dataSource = self
           Table.delegate = self
       }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
       
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCell
       
       
       cell.date.text = data[indexPath.row].date
       cell.pushups!.text = String(data[indexPath.row].pushups)
       return cell;
   }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           deleted.append(data[indexPath.row])
           data.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
        
       }
       
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       row = indexPath.row
   }
   
}

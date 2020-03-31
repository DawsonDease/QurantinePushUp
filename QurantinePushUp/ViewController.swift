//
//  ViewController.swift
//  QurantinePushUp
//
//  Created by Dawson on 2020-03-31.
//  Copyright © 2020 Dawson. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var dailyRecordLabel: UILabel!
    @IBOutlet weak var currentStreakLabel: UILabel!
    
    var entries = [Entry]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTable.dataSource = self
        historyTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier != "ShowController"){
            return
        }
        guard let addViewController = segue.destination.children[0] as? AddViewController else{
            fatalError("Unexpected Destination \(segue.destination)")
        }
        
        addViewController.data = entries
        
    }
    
    @IBAction func unwindToViewController(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddViewController{
            entries = sourceViewController.data
            
            print(entries.count)
            historyTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCell
        
        
        cell.date.text = entries[indexPath.row].date
        cell.pushups!.text = entries[indexPath.row].pushups
        return cell;
    }
    
}


//
//  ViewController.swift
//  QurantinePushUp
//
//  Created by Dawson on 2020-03-31.
//  Copyright © 2020 Dawson. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var dailyRecordLabel: UILabel!
    @IBOutlet weak var currentStreakLabel: UILabel!
    var row : Int = 0
    var entries = [Entry]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTable.dataSource = self
        historyTable.delegate = self
        entries = loadObjects() ?? entries
        // Do any additional setup after loading the view.
    }
    
    //MARK: Seque
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier != "ShowController"){
            return
        }
        guard let addViewController = segue.destination.children[0] as? AddViewController else{
            fatalError("Unexpected Destination \(segue.destination)")
        }
        
        addViewController.data = entries
        save()
        
    }
    
    @IBAction func unwindToViewController(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddViewController{
            entries = sourceViewController.data
            save()
            historyTable.reloadData()
        }
    }
    
    //MARK: TableView delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCell
        
        
        cell.date.text = entries[indexPath.row].date
        cell.pushups!.text = entries[indexPath.row].pushups
        return cell;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
    }
    
    
    
    
    //MARK: Load/Save
    
    func save(){
       do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: entries, requiringSecureCoding: false)
            try data.write(to: Entry.ArchiveURL)
            historyTable.reloadData()
        }catch{
            os_log("Cannot save due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
        }
    }
    
    func loadObjects() -> [Entry]? {
           do{
               let data = try Data(contentsOf: Entry.ArchiveURL)
               return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Entry]
           }catch{
               os_log("Cannot load due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
               return nil
           }
       }
    
}


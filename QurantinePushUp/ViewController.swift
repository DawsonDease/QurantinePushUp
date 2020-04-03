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
    var entries = [Entry]()
    var dailyPushups = [Entry]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTable.dataSource = self
        historyTable.delegate = self
        entries = loadObjects() ?? entries
        addPushups()
        // Do any additional setup after loading the view.
    }
    
    func addPushups(){
        if (entries.count < 1){
            return
        }
        
        //Searches through entries to calculate pushups
        var isSet : Bool = false
        let newEntry : Entry = Entry(date: entries[0].date, pushUps: 0)
        for entry in entries{
            if(newEntry.date == entry.date){
                newEntry.pushups += entry.pushups

            }
        }
        
        //Searches if the date is already recorded if not it is added to the dail pushups
        
        for entry in dailyPushups{
            if(newEntry.date == entry.date){
                entry.pushups = newEntry.pushups
                isSet = true
                break;
            }
        }
        
        if(!isSet){
            dailyPushups.insert(newEntry, at: 0)
        }
        
        
        
        
    }
    
    //MARK: Seque
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "ShowController"){
           
        
        guard let addViewController = segue.destination.children[0] as? AddViewController else{
            fatalError("Unexpected Destination \(segue.destination)")
        }
        
        addViewController.data = entries
        save()
        }else{
            print("in else")
            guard let historyViewController = segue.destination.children[0] as? HistoryViewController else{
                fatalError("Unexpected Destination \(segue.destination)")
            }
            
            historyViewController.data = entries
            save()
            
        }
        
    }
    
    @IBAction func unwindToViewController(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddViewController {
           
            entries = sourceViewController.data
            save()
            addPushups()
            
            historyTable.reloadData()
        }
        
         if let sourceViewController = sender.source as? HistoryViewController {
            print("Here")
           entries = sourceViewController.data
           save()
           addPushups()
           historyTable.reloadData()
       }
        
    }
    
    //MARK: TableView delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyPushups.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCell
        print(dailyPushups.count)
        print(indexPath.row)
        
        cell.date.text = dailyPushups[indexPath.row].date
        cell.pushups!.text = String(dailyPushups[indexPath.row].pushups)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dailyPushups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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


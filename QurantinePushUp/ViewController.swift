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
        dailyRecordLabel.text = "0"
        currentStreakLabel.text = "0"
        historyTable.dataSource = self
        historyTable.delegate = self
        entries = loadObjects() ?? entries
        dailyPushups = loadDaily() ?? dailyPushups
        findRecord()
        // Do any additional setup after loading the view.
    }
    
    func addPushups(postToBeAdded: Entry){
        var record = 0
        var isSet = false
        for entry in dailyPushups{
            if(postToBeAdded.date == entry.date){
                entry.pushups += postToBeAdded.pushups
                isSet = true
            }
            
            if(postToBeAdded.pushups > record){
                record = postToBeAdded.pushups
            }
        }
        
        if(!isSet){
            dailyPushups.insert(postToBeAdded, at: 0)
        }
        
        findRecord()
        historyTable.reloadData()
        saveDaily()
    }
    
    func removePushups(entryToBeDeleted: [Entry]){
       var record = 0
        for deletedEntry in entryToBeDeleted{
            for (index, entry) in dailyPushups.enumerated(){
                if(deletedEntry.date == entry.date){
                    entry.pushups -= deletedEntry.pushups
                    if(entry.pushups <= 0){
                        dailyPushups.remove(at: index)
                    }
                    break
                }
                if(record < entry.pushups){
                    record = entry.pushups
                }
            }
        }
        findRecord()
        saveDaily()
    }
    
    func findRecord(){
        var record = 0
        for entry in entries{
            if record < entry.pushups{
                record = entry.pushups
            }
        }
        dailyRecordLabel.text = String(record)
    }
    //MARK: Seque
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "ShowHistoryController"){
        
            guard let historyViewController = segue.destination.children[0] as? HistoryViewController else{
                fatalError("Unexpected Destination \(segue.destination)")
            }
            
            historyViewController.data = entries
            saveEntries()
            
        }
        
    }
    
    @IBAction func unwindToViewController(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddViewController {
           
            entries.insert(sourceViewController.data, at: 0)
            saveEntries()
            addPushups(postToBeAdded: sourceViewController.data)
            
            
        }else if let sourceViewController = sender.source as? HistoryViewController {
        
           entries = sourceViewController.data
           saveEntries()
            removePushups(entryToBeDeleted: sourceViewController.deleted)
           
       }
        
    }
    
    //MARK: TableView delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyPushups.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCell
        cell.date.text = dailyPushups[indexPath.row].date
        cell.pushups!.text = String(dailyPushups[indexPath.row].pushups)
        return cell;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              
              dailyPushups.remove(at: indexPath.row)
              tableView.deleteRows(at: [indexPath], with: .fade)
           
          }
    }
    
 
    //MARK: Load/Save
    func saveDaily(){
        do{
           let data = try NSKeyedArchiver.archivedData(withRootObject: dailyPushups, requiringSecureCoding: false)
           try data.write(to: Entry.ArchiveURLDaily)
           historyTable.reloadData()
   
       }catch{
           os_log("Cannot save due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
       }
    }
    
    func saveEntries(){
        
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
    func loadDaily() -> [Entry]? {
              do{
                  let data = try Data(contentsOf: Entry.ArchiveURLDaily)
                  return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Entry]
              }catch{
                  os_log("Cannot load due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
                  return nil
              }
          }
    
}


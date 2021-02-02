//
//  EntryListTableViewController.swift
//  CloudKitJournal
//
//  Created by Benjamin Tincher on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func loadData() {
        EntryController.shared.fetchAllEntries { (result) in
            DispatchQueue.main.async {
                switch result  {
                case .success(let entries):
                    print("loadData - \(entries.count)")
                    self.tableView.reloadData()
                case .failure(_):
                    print("unsuccessful fetching")
                }
            }
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows \(EntryController.shared.entries.count)")
        return EntryController.shared.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.dateToString(format: .monthDayYearTimestamp)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            EntryController.shared.delete(entry: EntryController.shared.entries[indexPath.row])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? EntryDetailViewController else { return }
            destination.entry = EntryController.shared.entries[indexPath.row]
        }
    }
    
}   //  End of Class

//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by Benjamin Tincher on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entry = entry {
            self.titleTextField.text = entry.title
            self.bodyTextView.text = entry.body
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let body = bodyTextView.text ?? "Your Entry Here..."
        
        if let entry = entry {
            EntryController.shared.update(entry: entry, with: title, with: body)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        EntryController.shared.createEntryWith(title: title, body: body) { (result) in
            DispatchQueue.main.async {
                switch result  {
                case .success(_):
                    print("successful creation")
                    self.navigationController?.popViewController(animated: true)
                case .failure(_):
                    print("unsuccessful created entry")
                }
            }
        }
    }
    
    @IBAction func clearTextButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        titleTextField.placeholder = "Entry Title..."
        bodyTextView.text = "Your Entry Here..."
    }
    
}   //  End of Class

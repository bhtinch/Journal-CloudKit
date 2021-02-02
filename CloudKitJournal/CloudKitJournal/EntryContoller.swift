//
//  EntryContoller.swift
//  CloudKitJournal
//
//  Created by Benjamin Tincher on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

class EntryController {
    
    static let shared = EntryController()
    
    var entries: [Entry] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func createEntryWith(title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let entry = Entry(title: title, body: body)
        let entryRecord = CKRecord(entry: entry)
        
        privateDB.save(entryRecord) { (record, error) in
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.thrownError(error)))
                }
                
                guard let record = record,
                      let entry = Entry(ckRecord: record) else { return completion(.failure(.createError)) }
                
                self.entries.append(entry)
                print("save-entries.count: \(self.entries.count)")
                completion(.success(entry))
        }
    }
    
    func fetchAllEntries(completion: @escaping (Result<[Entry], EntryError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.thrownError(error)))
                }
                
                guard let records = records else { return completion(.failure(.fetchError)) }
                
                let fetchedEntries = records.compactMap { Entry(ckRecord: $0) }
                self.entries = fetchedEntries
                print("fetch-entries.count: \(self.entries.count)")
                completion(.success(self.entries))
        }
    }
    
    func update(entry: Entry, with title: String, with body: String) {
        let ckRecordID = entry.ckRecordID
        let ckRecord = CKRecord(recordType: EntryStrings.recordTypeKey, recordID: ckRecordID)
        
        ckRecord.setValue(title, forKey: EntryStrings.titleKey)
        ckRecord.setValue(body, forKey: EntryStrings.bodyKey)
        
        guard let index = entries.firstIndex(of: entry) else { return }
        entries[index].title = title
        entries[index].body = body
    }
    
    func delete(entry: Entry)  {
        
        guard let index = entries.firstIndex(of: entry) else { return }
        
        privateDB.delete(withRecordID: entry.ckRecordID) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        entries.remove(at: index)
    }
    
}   //  End of Class

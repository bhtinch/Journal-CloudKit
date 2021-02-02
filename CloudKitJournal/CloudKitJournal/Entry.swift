//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Benjamin Tincher on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

struct EntryStrings {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    static let recordTypeKey = "Entry"
}

class Entry {
    
    var title: String
    var body: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}   //  End of Class

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        
        guard let body = ckRecord[EntryStrings.bodyKey] as? String,
              let title = ckRecord[EntryStrings.titleKey] as? String,
              let timestamp = ckRecord[EntryStrings.timestampKey] as? Date else { return nil }
        
        self.init(title: title, body: body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}   //  End of Extension

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryStrings.recordTypeKey, recordID: entry.ckRecordID)
        self.setValuesForKeys([
            EntryStrings.titleKey : entry.title,
            EntryStrings.bodyKey : entry.body,
            EntryStrings.timestampKey : entry.timestamp
        ])
    }
}   //  End of Extension

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}   //  End of Extension

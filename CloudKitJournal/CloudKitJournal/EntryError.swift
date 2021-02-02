//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by Benjamin Tincher on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case thrownError(Error)
    case fetchError
    case createError
}

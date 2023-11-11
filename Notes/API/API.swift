//
//  API.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import Foundation

class API {
    @discardableResult
    static func createNote(_ text: String) async -> Note? {
        await APIImplementation.createNote(text)
    }
    
    static func notes() async -> [Note] {
        await APIImplementation.notes()
    }
    
    static func note(_ id: String) async -> Note? {
        await APIImplementation.note(id)
    }
    
    @discardableResult
    static func updateNote(_ id: String, text: String) async -> Note? {
        await APIImplementation.updateNote(id, text: text)
    }
    
    @discardableResult
    static func deleteNote(_ id: String) async -> Bool {
        await APIImplementation.deleteNote(id)
    }
}

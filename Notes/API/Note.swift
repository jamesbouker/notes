//
//  Note.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import Foundation

struct Note: Decodable, Identifiable {
    var _id: String
    var note: String
    
    var title: String {
        note.title
    }
    
    var body: String {
        note.components(separatedBy: .newlines).dropFirst(1).joined(separator: "\n")
    }
    
    // Identifiable
    var id: String { _id }
}


extension String {
    var title: String {
        self.components(separatedBy: .newlines).first ?? ""
    }
}

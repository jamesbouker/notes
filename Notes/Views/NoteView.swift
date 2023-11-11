//
//  NoteView.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import SwiftUI

struct NoteView: View {
    let note: Note?
    var onSave: () -> Void
    
    @State private var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $text)
            Spacer()
        }
        .onAppear {
            text = note?.note ?? ""
        }
        .onDisappear {
            Task {
                if let note = note {
                    _=await API.updateNote(note._id, text: text)
                } else {
                    _=await API.createNote(text)
                }
                onSave()
            }
        }
        .navigationTitle(Text(text.title.isEmpty ? (note?.note.title ?? "") : text.title))
        .padding(.horizontal)
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: .init(_id: "", note: "Title of note\n\nBody of note.\n\nAnd everything else...")) {}
    }
}

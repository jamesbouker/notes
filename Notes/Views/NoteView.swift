//
//  NoteView.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import SwiftUI

private let placeholderText = "Type something..."

struct NoteView: View {
    let note: Note?
    var onSave: () -> Void
    
    @State private var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $text)
                .onTapGesture {
                    if text == placeholderText { text = "" }
                }
                .foregroundColor(text == placeholderText ? .secondary : .primary)
            Spacer()
        }
        .onAppear {
            text = note != nil ? note!.note : placeholderText
        }
        .onDisappear {
            Task {
                if let note = note {
                    await API.updateNote(note._id, text: text)
                } else if text != placeholderText && !text.isEmpty {
                    await API.createNote(text)
                }
                onSave()
            }
        }
        .navigationTitle(Text(text.title.isEmpty ? (note?.note.title ?? placeholderText) : text.title))
        .padding(.horizontal)
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: .init(_id: "", note: "Title of note\n\nBody of note.\n\nAnd everything else...")) {}
    }
}

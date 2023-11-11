//
//  NoteView.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import SwiftUI

struct NoteView: View {
    let note: Note?
    
    @State private var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $text)
            Spacer()
        }
        .onAppear {
            text = note?.note ?? ""
        }
        .navigationTitle(Text(text.title))
        .padding(.horizontal)
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: .init(_id: "", note: "Title of note\n\nBody of note.\n\nAnd everything else..."))
    }
}

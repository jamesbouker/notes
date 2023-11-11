//
//  HomeView.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import SwiftUI

struct HomeView: View {
    @State private var notes: [Note] = []
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink {
                    NoteView(note: note) {
                        loadNotes()
                    }
                } label: {
                    Text(note.title)
                }
            }
            .onDelete(perform: onDelete)
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    NoteView(note: nil) {
                        loadNotes()
                    }
                } label: {
                    Text("Add")
                }
            }
        })
        .navigationTitle(Text("Notes"))
        .onAppear(perform: loadNotes)
    }
    
    func onDelete(_ indexSet: IndexSet) {
        let deleteUs = indexSet.map { notes[$0] }
        Task {
            for note in deleteUs {
                await API.deleteNote(note._id)
            }
        }
        notes.remove(atOffsets: indexSet)
    }
    
    func loadNotes() {
        Task {
            notes = await API.notes()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}

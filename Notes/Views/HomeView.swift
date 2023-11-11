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
        List(notes) { note in
            NavigationLink {
                NoteView(note: note) {
                    loadNotes()
                }
            } label: {
                Text(note.title)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    
                }
            }
        })
        .navigationTitle(Text("Notes"))
        .onAppear(perform: loadNotes)
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

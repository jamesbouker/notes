//
//  ContentView.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<notes.count, id: \.self) {
                    Text(notes[$0]._id)
                }
            }
        }
        .navigationTitle(Text("Notes"))
        .onAppear {
            Task {
                await loadNotes()
            }
        }
    }
    
    func loadNotes() async {
        notes = await API.notes()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

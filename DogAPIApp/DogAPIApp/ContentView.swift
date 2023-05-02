//
//  ContentView.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 2.05.23.
//

import SwiftUI
import DogAPIPackage

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(DogAPIPackage().text)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

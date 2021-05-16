//
//  ContentView.swift
//  DiceRoller
//
//  Created by Kristoffer Eriksson on 2021-05-14.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var resultsList = ResultsList()
    
    var body: some View {
        
        TabView{
            DiceView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Dice")
                }
            ResultsView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Results")
                }
        }
        .environmentObject(resultsList)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

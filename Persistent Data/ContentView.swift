//
//  ContentView.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import SwiftUI

struct ContentView: View {
    let service = DataService()
    
    var body: some View {
        VStack {
            HeaderView()
                .frame(
                    height: 100
                )
            
            DataListView()
                .frame(
                    maxHeight: .infinity
                )
            
            FooterView()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 75
                )
                .background(
                    Color.white
                )
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0.0, y: -2)
        }.ignoresSafeArea(.all)
        .environmentObject(service)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

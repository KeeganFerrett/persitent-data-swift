//
//  FooterView.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import SwiftUI

struct FooterView: View {
    @EnvironmentObject var dataService: DataService
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: loadButtonPressed, label: {
                    Text("Load Events")
                        .font(.caption)
                })
                Button(action: clearButtonPressed, label: {
                    Text("Clear Events")
                        .font(.caption)
                })
            }
        }

    }
    
    func loadButtonPressed() {
        dataService.readData()
    }
    
    func clearButtonPressed() {
        dataService.clearData()
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
            .previewLayout(.fixed(width: 300, height: 70))
            .environmentObject(DataService())
    }
}

//
//  Persistent_DataApp.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import SwiftUI
import RealmSwift

@main
struct Persistent_DataApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    print(Realm.Configuration.defaultConfiguration.fileURL)
                    print(Realm.Configuration.defaultConfiguration.encryptionKey)
                })
        }
    }
}

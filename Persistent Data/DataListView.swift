//
//  DataListView.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import SwiftUI

struct DataListView: View {
    @EnvironmentObject var dataStore: DataService
    
    var body: some View {
        VStack {
            if (dataStore.events.count > 0) {
                ScrollView {
                    LazyVStack {
                        ForEach(dataStore.events, id: \.guid) { event in
                            EventListItemView(event: event)
                        }
                    }
                }
            } else {
                Text("No data found!")
            }
        }
    }
}

struct DataListView_Previews: PreviewProvider {
    static var CleanDataStore: DataService {
        return DataService()
    }
    
    static var FullDataStore: DataService {
        let service = DataService()
        service.events = [
            Event(
                guid: "A",
                location: "Advance Main office",
                title: "Sale of IoT services",
                person: Person(
                    title: "Mr",
                    lastName: "Smith",
                    job: "Director",
                    company: "Advance"
                )
            )
        ]
        
        return service
    }
    
    static var previews: some View {
        DataListView()
            .environmentObject(CleanDataStore)
        
        DataListView()
            .environmentObject(FullDataStore)
    }
}

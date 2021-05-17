//
//  EventListItemView.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import SwiftUI

struct EventListItemView: View {
    var event: Event
    
    var body: some View {
        VStack {
            Text("\(event.title.capitalized)")
                .font(.body)
                .bold()
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text("\(event.location.capitalized) - \(event.person?.getPersonText() ?? "")")
                .font(.caption)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Divider()
                .padding(.leading)
                .frame(height: 0)
        }
    }
}

struct EventListItemView_Previews: PreviewProvider {
    static var previews: some View {
        EventListItemView(
            event: Event(
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
        )
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

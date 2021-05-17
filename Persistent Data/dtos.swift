//
//  EventDto.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import Foundation

class EventDto: NSObject, Codable {
    var guid: String
    var title: String
    var location: String
    var person: PersonDto
    
    public override var description: String {
       return "EventDto: {"
        + "guid: \(guid),"
        + "}"
   }
}

class PersonDto: Codable {
    var title: String
    var last_name: String
    var job: String
    var company: String
}

//
//  Event.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var guid: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var person: Person?
    @objc dynamic var randomVal = UUID().uuidString
    
    override init() { }
    
    convenience init(guid: String, location: String, title: String, person: Person) {
        self.init()
        self.guid = guid
        self.location = location
        self.title = title
        self.person = person
    }
    
    convenience init(dto: EventDto) {
        self.init(
            guid: dto.guid,
            location: dto.location,
            title: dto.title,
            person: Person(dto: dto.person)
        )
    }
    
    override class func primaryKey() -> String? {
        return "guid"
    }
}

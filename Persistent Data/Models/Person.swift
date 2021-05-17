//
//  Person.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import Foundation
import RealmSwift

class Person: EmbeddedObject {
    @objc dynamic var title: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var job: String = ""
    @objc dynamic var company: String = ""
    
    override init() { }

    convenience init(title: String, lastName: String, job: String, company: String) {
        self.init()
        self.title = title
        self.lastName = lastName
        self.job = job
        self.company = company
    }
    
    convenience init(dto: PersonDto) {
        self.init(
            title: dto.title,
            lastName: dto.last_name,
            job: dto.job,
            company: dto.company
        )
    }
    
    func getPersonText() -> String {
        return "\(self.title) \(self.lastName) (\(self.job))"
    }
}

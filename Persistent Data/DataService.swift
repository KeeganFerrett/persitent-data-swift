//
//  DataService.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import Foundation
import Combine
import RealmSwift

class DataService: ObservableObject {
    var subs: [AnyCancellable] = []
    
    @Published var events: [Event] = []
    
    init() {
        let startTime = CFAbsoluteTimeGetCurrent()
        let realm = try! Realm(configuration: .defaultConfiguration)
        self.events = Array(realm.objects(Event.self))
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for init: \(timeElapsed) secs.")
    }
    
    func readData() {
        let startTime = CFAbsoluteTimeGetCurrent()
        let publisher: AnyPublisher<[EventDto], Error> = load("data.json")

        publisher
            .map({ data -> [Event] in
                return data.map({ Event(dto: $0) })
            })
            .saveToRealm()
            .sink { (result) in

            } receiveValue: { data in
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                print("Time elapsed for readData: \(timeElapsed) secs.")
                self.events = data
            }.store(in: &self.subs)
    }
    
    func clearData() {
        events = []
    }
    
    private func load<T: Decodable>(_ filename: String) -> AnyPublisher<T, Error> {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        return Just(data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

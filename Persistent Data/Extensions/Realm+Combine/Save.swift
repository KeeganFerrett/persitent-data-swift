//
//  Save.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import Foundation
import Combine
import RealmSwift

extension Publishers {
    struct SaveObjectsToRealm<Upstream: Publisher>: Publisher where Upstream.Output: Swift.Sequence, Upstream.Output.Iterator.Element: Object  {
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure
        
        private let upstream: Upstream
        
        init(upstream: Upstream) {
            self.upstream = upstream
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            subscriber.receive(subscription: Subscription(upstream: upstream, downstream: subscriber))
        }
    }
}

extension Publishers.SaveObjectsToRealm {
    class Subscription<Downstream: Subscriber>: Combine.Subscription where Upstream.Output: Sequence, Upstream.Output.Iterator.Element: Object, Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure {
        private var sink: SaveObjectsSink<Upstream, Downstream>?
        
        init(upstream: Upstream, downstream: Downstream) {
            sink = .init(upstream: upstream, downstream: downstream)
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            sink = nil
        }
    }
}

class SaveObjectsSink<Upstream: Publisher, Downstream: Subscriber>: Subscriber where Upstream.Output == Downstream.Input, Downstream.Failure == Upstream.Failure {
    private var downstream: Downstream
    private var _element: Upstream.Output?
    
    init(upstream: Upstream, downstream: Downstream) {
        self.downstream = downstream
        upstream.subscribe(self)
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Upstream.Output) -> Subscribers.Demand {
        _element = input
        if let seq = _element as? [Object] {
            do {
                let realm = try Realm(configuration: .defaultConfiguration)
                try realm.write {
                    self.addToRealm(realm, input: seq, updatePolicy: .modified)
                }
            } catch let error {
                print(error)
            }
        }
        
        _ = downstream.receive(input)
        downstream.receive(completion: .finished)
        
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Upstream.Failure>) {
        switch completion {
        case .failure(let err):
            downstream.receive(completion: .failure(err))
        case .finished:
            break
        }
    }
    
    func addToRealm(_ realm: Realm, input: [Object], updatePolicy: Realm.UpdatePolicy) {
        realm.add(input, update: updatePolicy)
    }
    
    func addToRealm(_ realm: Realm, input: Object, updatePolicy: Realm.UpdatePolicy) {
        realm.add(input, update: updatePolicy)
    }
}


extension Publisher where Output: Sequence, Failure: Error, Output.Iterator.Element: Object  {
    func saveToRealm() -> Publishers.SaveObjectsToRealm<Self> {
        return Publishers.SaveObjectsToRealm(upstream: self)
    }
}


//
//  Reply.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import Foundation
import Combine
import RealmSwift

extension Publishers {
    struct RealmSavingThing<Upstream: Publisher>: Publisher where Upstream.Output == [Object] {
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

extension Publishers.RealmSavingThing {
    class Subscription<Downstream: Subscriber>: Combine.Subscription where Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure, Upstream.Output == [Object]
    {
        private var sink: RealmSavingThingSink<Upstream, Downstream>?

        init(upstream: Upstream, downstream: Downstream) {
            sink = .init(upstream: upstream, downstream: downstream)
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            sink = nil
        }
    }
}

class RealmSavingThingSink<Upstream: Publisher, Downstream: Subscriber>: Subscriber where Upstream.Output == Downstream.Input, Downstream.Failure == Upstream.Failure, Upstream.Output == [Object]
{
    private var downstream: Downstream
    private var _element: Upstream.Output?

     init(upstream: Upstream, downstream: Downstream) {
        self.downstream = downstream
        upstream.subscribe(self)
    }

     func receive(subscription: Subscription) {
        print("receive(subscription: Subscription)")
        subscription.request(.max(1))
    }

     func receive(_ input: Upstream.Output) -> Subscribers.Demand {
        print("receive(_ input: Upstream.Output)")
        _element = input
        print("_element:", _element?.count)
//        if let elements = _element as? [Object] {
//            for el in elements {
//                print(el)
//            }
//        }


        _ = downstream.receive(input)
        downstream.receive(completion: .finished)

        return .none
    }

     func receive(completion: Subscribers.Completion<Upstream.Failure>) {
        print("receive(completion: Subscribers.Completion<Upstream.Failure>)")

        switch completion {
        case .failure(let err):
            downstream.receive(completion: .failure(err))
        case .finished:
            if _element == nil {
                fatalError("❌ Sequence doesn't contain any elements.")
            }
        }
    }
}

extension Publisher where Output == [Object] {
    func asSingle() -> Publishers.RealmSavingThing<Self> {
        return Publishers.RealmSavingThing(upstream: self)
    }
}

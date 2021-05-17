//
//  Single.swift
//  Persistent Data
//
//  Created by Keegan Ferrett on 2021/04/17.
//

import Foundation
import Combine

extension Publishers {
  struct AsSingle<Upstream: Publisher>: Publisher where Upstream.Output == [Int] {
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

extension Publishers.AsSingle {
    class Subscription<Downstream: Subscriber>: Combine.Subscription where Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure, Upstream.Output == [Int] {
        private var sink: AsSingleSink<Upstream, Downstream>?

         init(upstream: Upstream, downstream: Downstream) {
            sink = .init(upstream: upstream, downstream: downstream)
        }

         func request(_ demand: Subscribers.Demand) { }

         func cancel() {
            sink = nil
        }
    }
}

class AsSingleSink<Upstream: Publisher, Downstream: Subscriber>: Subscriber where Upstream.Output == Downstream.Input, Downstream.Failure == Upstream.Failure {
    private var downstream: Downstream
    private var _element: Upstream.Output?

     init(upstream: Upstream, downstream: Downstream) {
        self.downstream = downstream
        upstream.subscribe(self)
    }

    func receive(subscription: Subscription) {
        print("receive(subscription: Subscription)")
        subscription.request(.unlimited)
    }

     func receive(_ input: Upstream.Output) -> Subscribers.Demand {
        print("receive(_ input: Upstream.Output)")

        _element = input
        if let arr = _element as? [Int] {
            print("Upstream.Output is [Int]")
            _ = downstream.receive(arr.map({ $0 + 1 }) as! Upstream.Output)
        } else {
            _ = downstream.receive(input)
        }
        downstream.receive(completion: .finished)
        
        return .none
    }

     func receive(completion: Subscribers.Completion<Upstream.Failure>) {
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

extension Publisher where Output == [Int] {
  func asSingle() -> Publishers.AsSingle<Self> {
      return Publishers.AsSingle(upstream: self)
  }
}

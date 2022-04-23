//
//  StreamsExtensions.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import Foundation
import RxSwift
import RxCocoa

public class ReadonlyStream<Element>: ObservableType {
    fileprivate let relay: BehaviorRelay<Element>
    
    public func value() -> Element {
        return relay.value
    }
    
    public init(value: Element) {
        relay = BehaviorRelay(value: value)
    }
    
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.Element == Element {
        return relay.subscribe(observer)
    }
    
    public func asObservable() -> Observable<Element> {
        return relay.asObservable()
    }
}

public class ObserverStream<Element: Equatable>: ReadonlyStream<Element>, ObserverType {
    // Allows bind(to:) api.
    public func on(_ event: Event<Element>) {
        switch event {
        case .next(let e):
            relay.accept(e)
            
        case .completed:
            // We ignore completion events from uplink observables.
            break
            
        default:
            // This should never happen as relays never complete or fail by definition.
            fatalError("MutableStream messed up")
        }
    }
}

public final class MutableStream<Element: Equatable>: ObserverStream<Element> {
    public func onNext(_ element: Element, force: Bool = false) {
        guard force || relay.value != element else { return }
        relay.accept(element)
    }
}

public extension MutableStream where Element: ExpressibleByNilLiteral {
    func onPulse(_ element: Element, force: Bool = false) {
        onNext(element, force: force)
        onNext(nil, force: force)
    }
}

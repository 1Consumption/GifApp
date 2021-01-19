//
//  Observable.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

final class Observable<T> {
    
    typealias Handler = (T) -> Void
    
    var value: T {
        didSet {
            notify()
        }
    }
    private var observers: [UUID: Handler] = [UUID: Handler]()
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ handler: @escaping (T) -> Void) -> Cancellable {
        let id = UUID()
        observers[id] = handler
        
        let cancellable = Cancellable { [weak self] in
            self?.observers[id] = nil
        }
        
        return cancellable
    }
    
    func fire() where T == Void {
        notify()
    }
    
    private func notify() {
        observers.values.forEach {
            $0(value)
        }
    }
}

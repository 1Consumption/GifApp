//
//  Cancellable.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

typealias CancellableBag = Set<Cancellable?>

final class Cancellable {
    
    private var handler: () -> Void?
    
    init(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    deinit {
        cancel()
    }
    
    func cancel() {
        handler()
    }
    
    func store(in bag: inout CancellableBag) {
        bag.insert(self)
    }
}

extension Cancellable: Hashable {
    static func == (lhs: Cancellable, rhs: Cancellable) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

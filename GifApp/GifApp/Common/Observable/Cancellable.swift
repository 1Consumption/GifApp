//
//  Cancellable.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

//typealias CancellableBag = Set<Cancellable>

final class Cancellable {
    
    private var handler: () -> Void?
    
    init(_ handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func cancel() {
        handler()
    }
}

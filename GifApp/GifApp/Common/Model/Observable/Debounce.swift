//
//  Debounce.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

final class Debounce<T> {
    
    typealias Handler = (T) -> Void
    
    var value: T {
        didSet {
            notify()
        }
    }
    private var observers: [UUID: Handler] = [UUID: Handler]()
    private let wait: TimeInterval
    private var timer: Timer?
    
    init(value: T, wait: TimeInterval) {
        self.value = value
        self.wait = wait
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
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: wait, repeats: false, block: { [weak self] _ in
            self?.observers.values.forEach {
                guard let value = self?.value else { return }
                $0(value)
            }
        })
    }
}

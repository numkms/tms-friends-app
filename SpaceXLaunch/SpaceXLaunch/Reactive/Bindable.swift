//
//  Bindable.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

class Bindable<T> {
    var value: T? {
        didSet {
            handlers.forEach { closure in
                closure(value)
            }
        }
    }
    
    private var handlers: [(T?) -> Void] = []
    
    func bind(_ handler: @escaping (T?) -> Void) {
        handlers.append(handler)
    }
}


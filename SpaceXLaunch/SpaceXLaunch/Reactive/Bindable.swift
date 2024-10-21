//
//  Bindable.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

class Bindable<T> {
    private var handlers: [(T?) -> Void] = []
    
    var value: T? {
        didSet {
            handlers.forEach { closure in
                closure(value)
            }
        }
    }
    
    func bind(_ handler: @escaping (T?) -> Void) {
        handlers.append(handler)
    }
}

//
//  Middleware.swift
//  ReduxUIKit
//
//  Created by Vladimir Kalinichenko on 5/27/19.
//

import Foundation

open
class Middleware<State> {
    public init() { }
    open func dispatch(_ store: Store<State>, _ action: Any, next: (Any) -> Void) {
        fatalError("Override this method and do not call super on it")
    }
}

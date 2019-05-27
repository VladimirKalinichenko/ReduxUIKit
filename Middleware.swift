//
//  Middleware.swift
//  ReduxUIKit
//
//  Created by Vladimir Kalinichenko on 5/27/19.
//

import Foundation

public
protocol Middleware {
    func dispatch<State>(_ store: Store<State>, _ action: Any, next: (Any) -> ())
}

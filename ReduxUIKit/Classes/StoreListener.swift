//
//  StoreListener.swift
//  ReduxUIKit
//
//  Created by Vladimir Kalinichenko on 5/27/19.
//

import Foundation

public
protocol StoreListener: class {
    associatedtype State
    func storeUpdated(store: Store<State>)
}

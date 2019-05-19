//
//  StoreView.swift
//  ReduxUIKit
//
//  Created by Vladimir Kalinichenko on 5/4/19.
//

import Foundation

/// UI element that can represent application state.
public protocol StoreView: StoreListener {
    associatedtype State
    associatedtype ViewModel
    typealias Converter = (Store<State>) -> ViewModel
    func setConverter(_ converter: @escaping Converter)
    func setViewModel(_ viewModel: ViewModel)
    func subscribeToStore()
    func unsubscribeFromStore()
    func onStoreUpdate(vm: ViewModel)
}

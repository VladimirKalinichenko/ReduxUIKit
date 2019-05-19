//
//  StoreViewController.swift
//  ReduxUIKit
//
//  Created by Vladimir Kalinichenko on 5/4/19.
//

import UIKit

/// - note: Must not be initized directly
/// Use StoreConnector to get instaces of this class.
open
class StoreViewController<State, ViewModel>: UIViewController, StoreView {
    public
    typealias State = State
    public
    typealias ViewModel = ViewModel
    
    public
    private(set)
    var viewModel: ViewModel!
    public
    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    private var converter: Converter!
    public
    func setConverter(_ converter: @escaping Converter) {
        self.converter = converter
    }
    
    /// Do not call this directly
    public
    func storeUpdated(store: Store<State>) {
        viewModel = converter(store)
        DispatchQueue.main.async {
            self.onStoreUpdate(vm: self.viewModel)
        }
    }
    
    public
    func subscribeToStore() {
        Store<State>.current().addListerner(self)
    }
    
    public
    func unsubscribeFromStore() {
        Store<State>.current().removeListerner(self)
    }
    
    /// Notifies on store updates. Override it to update UI on changes.
    open
    func onStoreUpdate(vm: ViewModel) { }
    
    open
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onStoreUpdate(vm: viewModel)
    }
}


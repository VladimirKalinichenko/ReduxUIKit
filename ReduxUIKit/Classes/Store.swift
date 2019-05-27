//
//  Store.swift
//  ReduxUIKit
//
//  Created by Vladimir Kalinichenko on 4/25/19.
//

import Foundation

/// App's state store.
public
class Store<State> {
    
    public
    init(initialState: State, reducer: @escaping (State, Any) -> State, middlewares: [Middleware] = []) {
        assert(StoreContainer.store == nil, "Store already initialized")
        self.state = initialState
        self.reducer = reducer
        self.middlewares = middlewares
        StoreContainer.store = self
    }
    
    public
    static func current() -> Store<State> {
        return StoreContainer.currentState()
    }
    
    public
    private(set) var state: State
    
    public
    func dispatch(_ action: Any) {
        dispatchQueue.sync {
            dispatch(action, state: self.state, middlewares: self.middlewares)
            notifyListeners()
        }
    }
    
    public
    func addListerner<Listener: StoreListener>(_ listener: Listener) where Listener.State == State {
        listeners.append(AnyStoreListerner(listener))
    }
    
    public
    func removeListerner<Listener: StoreListener>(_ listerner: Listener) where Listener.State == State {
        listeners.removeAll(where: { $0.listener === listerner })
    }
    

    private let dispatchQueue = DispatchQueue(label: "Store syncing queue")
    private let reducer: (State, Any) -> State
    private let middlewares: [Middleware]
    private var listeners: [AnyStoreListerner<State>] = []
    
    private func dispatch(_ action: Any,
                          state: State,
                          middlewares: [Middleware],
                          middlewareIndex: Int = 0) {
        guard middlewares.count > middlewareIndex else {
            self.state = reducer(state, action)
            return
        }
        middlewares[middlewareIndex].dispatch(self, action) { (nextAction) in
            dispatch(
                nextAction,
                state: state,
                middlewares: middlewares,
                middlewareIndex: middlewareIndex + 1
            )
        }
    }
        
    private func notifyListeners() {
        listeners.forEach { $0.storeUpdated(store: self) }
    }
}

fileprivate class StoreContainer {
    fileprivate static var store: Any?
    
    static func currentState<State>() -> Store<State> {
        return store as! Store<State>
    }
}

fileprivate class AnyStoreListerner<State>: StoreListener {
    typealias State = State
    func storeUpdated(store: Store<State>) {
        storeUpdatedBlock(store)
    }
    
    let listener: AnyObject
    private let storeUpdatedBlock: (Store<State>) -> ()
    
    init<Listerner: StoreListener>(_ listener: Listerner) where Listerner.State == State {
        self.listener = listener
        storeUpdatedBlock = { store in
            listener.storeUpdated(store: store)
        }
    }
}

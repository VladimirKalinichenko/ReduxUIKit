//
//  AppDelegate.swift
//  ReduxUIKit
//
//  Created by VladimirKalinichenko on 05/20/2019.
//  Copyright (c) 2019 VladimirKalinichenko. All rights reserved.
//

import ReduxUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let store = Store<AppState>(
            initialState: AppState(bool: false),
            reducer: appReducer,
            middlewares: [
                MyMiddleware(),
            ]
        )
        
        self.window = UIWindow()
        FirstRouter.init().start(window: self.window!)
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

struct AppState {
    let bool: Bool
}

struct SetAction { }

func appReducer(_ state: AppState, _ action: Any) -> AppState {
    switch action {
    case is SetAction:
        return AppState(bool: true)
    default:
        return AppState(bool: false)
    }
}


class FirstRouter {
    func start(window: UIWindow) {
        var vc: UIViewController!
        let firstStoreConnector = StoreConnector<ViewController>(
            builder: firstBuilder,
            converter: { store in
                FirstViewModel(
                    bool: store.state.bool,
                    onPress: { PresentRouter().start(vc) }
                )
            }
        )
        vc = firstStoreConnector.makeView()
        window.rootViewController = vc
    }
}

class PresentRouter {

    func start(_ vc: UIViewController) {
        var thisVC: UIViewController!
        let secondStoreConnector = StoreConnector<PresentViewContoller>(
            builder: presentBuilder,
            converter: { store in
                PresentViewModel(
                    onPress: { store.dispatch(SetAction()) },
                    onBack: { thisVC.dismiss(animated: true) }
                )
            }
        )
        thisVC = secondStoreConnector.makeView()
        vc.present(thisVC, animated: true)
    }
}

class MyMiddleware: Middleware<AppState> {
    override func dispatch(_ store: Store<AppState>, _ action: Any, next: (Any) -> Void) {
        print("My state was \(store.state.bool)")
        next(action)
        print("Now my state is \(store.state.bool)")
    }
}

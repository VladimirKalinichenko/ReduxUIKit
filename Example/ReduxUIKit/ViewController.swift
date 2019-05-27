//
//  ViewController.swift
//  ReduxUIKit
//
//  Created by VladimirKalinichenko on 05/20/2019.
//  Copyright (c) 2019 VladimirKalinichenko. All rights reserved.
//

import ReduxUIKit

func firstBuilder() -> ViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let vc = storyboard.instantiateInitialViewController() as! ViewController
    return vc
}

struct FirstViewModel {
    let bool: Bool
    let onPress: () -> Void
}

class ViewController: StoreViewController<AppState, FirstViewModel> {

    @IBOutlet var label: UILabel!
    
    @IBAction func pressed() {
        viewModel.onPress()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToStore()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromStore()
    }
    
    override func onStoreUpdate(vm: FirstViewModel) {
        if vm.bool {
            label.text = "YES"
        } else {
            label.text = "NO"
        }
    }
}

func presentBuilder() -> PresentViewContoller {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let vc = storyboard.instantiateViewController(withIdentifier: "PresentViewContoller") as! PresentViewContoller
    return vc
}

struct PresentViewModel {
    let onPress: () -> Void
    let onBack: () -> Void
}

class PresentViewContoller: StoreViewController<AppState, PresentViewModel> {
    @IBAction func backPressed() {
        viewModel.onPress()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.onBack()
        }
    }
}


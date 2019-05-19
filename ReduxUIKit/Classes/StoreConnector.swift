//
//  StoreConnector.swift
//  ReduxUIKit
//
//  Created by Vladimir Kalinichenko on 5/4/19.
//

import Foundation

public
class StoreConnector<View> where View: StoreView {
    public
    typealias Builder = () -> View
    
    public
    init(builder: @escaping Builder,
         converter: @escaping View.Converter) {
        self.builder = builder
        self.converter = converter
    }
    
    let builder: Builder
    let converter: View.Converter
    
    public
    func makeView() -> View {
        let view = builder()
        view.setConverter(converter)
        view.setViewModel(converter(Store<View.State>.current()))
        return view
    }
}

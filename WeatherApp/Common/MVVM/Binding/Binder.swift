//
//  Binder.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 19.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

protocol Binder: class {
    func bind()
}

class BaseBinder<View: BaseViewController, ViewModel: BaseViewModel>: Binder {
    var view: View
    var viewModel: ViewModel
    
    init(view: View, viewModel: ViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
    
    func bind() {
        bindLoader()
    }
}

private extension BaseBinder {
    func bindLoader() {
        viewModel.isLoading.subscribe(onNext: { [unowned view] isLoading in
            if isLoading {
                view.onStartLoading()
            } else {
                view.onStopLoading()
            }
        }).disposed(by: view.disposeBag)
    }
}

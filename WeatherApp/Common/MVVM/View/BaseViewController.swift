//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 19.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var viewModel: ViewModel?
    weak var binder: Binder?
    
    var loader: ProgressHUD?
    private(set) var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binder?.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel?.stop()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        loader?.hide()
    }
}

extension BaseViewController {
    func onStartLoading() {
        loader?.show(for: self)
    }
    
    func onStopLoading() {
        loader?.hide()
    }
}

//
//  ViewController.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import UIKit
import Then
import SnapKit
import ReactorKit

class NewsMainViewController: UIViewController, View {
  
  // MARK: - components
  
  private let baseView = UIView().then {
    $0.backgroundColor = .white
  }
  
  
  
  
  // MARK: - private properties
  
  // MARK: - internal properties
  
  var disposeBag: RxSwift.DisposeBag = DisposeBag()
  
  
  // MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    
    self.reactor?.action.onNext(.loadNews)
  }
  
  func bind(reactor: NewsMainReactor) {
    
    // state
    
    reactor.pulse { $0.news }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { news in
        print("news ~> \(String(describing: news))")
      })
      .disposed(by: self.disposeBag)
    
    reactor.pulse { $0.error }
      .compactMap({ $0 })
      .subscribe(onNext: { error in
        print(error)
      })
      .disposed(by: self.disposeBag)
      
  }
  
  
  // MARK: - private methods
  
  private func setup() {
    self.baseView.setSnpLayout(baseView: self.view) { make in
      make.edges.equalToSuperview()
    }
    
  }
  
  
  // MARK: - internal methods
  
  
}


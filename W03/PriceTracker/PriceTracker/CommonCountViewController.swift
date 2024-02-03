//
//  ViewController.swift
//  PriceTracker
//
//  Created by 송하민 on 2/3/24.
//

import UIKit
import SnapKit
import Then

class CommonCountViewController: UIViewController, CommonSocketConnectorDelegate {

  
  // MARK: - component
  
  private let baseView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let label = UILabel().then {
    $0.text = "0"
    $0.font = .systemFont(ofSize: 20, weight: .regular)
  }
  
  
  // MARK: - private properties
  
  private let socketConnector: CommonSocketConnector
  
  private var totalSum: Int = 0
  
  
  // MARK: - life cycle
  
  init(socket: CommonSocketConnector) {
    self.socketConnector = socket
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setup()
    self.connectSocket()
  }
  
  
  // MARK: - private methods
  
  private func setup() {
    self.view.addSubview(self.baseView)
    self.baseView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.baseView.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
    
  }
  
  private func connectSocket() {
    self.socketConnector.connect(url: URL(string: "ws://localhost:3001")!)
    self.socketConnector.delegate = self
    self.socketConnector.receive()
    
  }

  // MARK: - method
  
  func didReceiveMessage(_ message: String) {
    guard !message.contains("Sum") else {
      print("message from Server: \(message), client: \(self.socketConnector.getValue())")
      DispatchQueue.main.async {
        self.label.text = "0"
      }
      return
    }
    
    DispatchQueue.main.async {
      self.label.text = message
    }
  }
}


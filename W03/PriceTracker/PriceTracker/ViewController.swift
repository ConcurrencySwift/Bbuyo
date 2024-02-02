//
//  ViewController.swift
//  PriceTracker
//
//  Created by 송하민 on 2/1/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController, ActorSocketConnectorDelegate, CommonSocketConnectorDelegate {

  
  // MARK: - component
  
  private let baseView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let label = UILabel().then {
    $0.text = "0"
    $0.font = .systemFont(ofSize: 20, weight: .regular)
  }
  
  
  // MARK: - private properties
  
  private let socketConnector: any AsyncSocketProtocol
  
  private var totalSum: Int = 0
  
  
  // MARK: - life cycle
  
  init(socket: any AsyncSocketProtocol) {
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
    Task {
      await self.socketConnector.connect(url: URL(string: "ws://localhost:3001")!)
      if let actorSocketConnector = self.socketConnector as? ActorSocketConnector {
        await actorSocketConnector.setDelegate(self)
      } else if let commonSocketConnector = self.socketConnector as? CommonSocketConnector {
        await commonSocketConnector.setDelegate(self)
      }
      await self.socketConnector.receive()
    }
  }

  // MARK: - method
  
  func didReceiveMessage(_ message: String) {
    guard !message.contains("Sum") else {
      print("message from Server: \(message), client: \(self.totalSum)")
      self.totalSum = .zero
      return
    }
    DispatchQueue.main.async {
      self.label.text = message
    }
    
    if let message = Int(message) {
      self.totalSum += message
    }
  }
  

}


//
//  CommonSocketConnector.swift
//  PriceTracker
//
//  Created by 송하민 on 2/3/24.
//

import Foundation


protocol CommonSocketConnectorDelegate: AnyObject {
  func didReceiveMessage(_ message: String)
}

class CommonSocketConnector: CommonSocketProtocol {
  
  
  // MARK: - private properties
  
  private var socketTask: URLSessionWebSocketTask?
  private let urlSession = URLSession(configuration: .default)
  
  
  // MARK: - properties
  
  var message: String?
  var totalSum: Int = 0
  
  weak var delegate: CommonSocketConnectorDelegate?
  
  
  // MARK: - life cycle
  
  // MARK: - private method
  
  
  // MARK: - internal method
  
  func connect(url: URL) {
    self.socketTask = self.urlSession.webSocketTask(with: url)
    self.socketTask?.resume()
    
    print("common socket connected")
  }
  
  func receive() {
    self.socketTask?.receive { [weak self] result in
      switch result {
        case .success(let message):
          switch message {
            case .string(let text):
              DispatchQueue.global().async {
                self?.totalSum += Int(text) ?? 0
                self?.delegate?.didReceiveMessage(text)
              }
            case .data:
              break
            @unknown default:
              fatalError()
          }
          DispatchQueue.global().async {
            self?.receive()
          }
        case .failure(let error):
          print("\(error)")
      }
    }
  }

  func disconnect() {
    self.socketTask?.cancel()
  }
  
  func getValue() -> Int {
    return self.totalSum
  }
  
}

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

class CommonSocketConnector: AsyncSocketProtocol {
  
  
  // MARK: - private properties
  
  private var socketTask: URLSessionWebSocketTask?
  private let urlSession = URLSession(configuration: .default)
  
  
  // MARK: - properties

  weak var delegate: CommonSocketConnectorDelegate?
  
  var message: String? {
    didSet {
      notifyDelegate(message: message ?? "0")
    }
  }
  
  
  // MARK: - life cycle
  
  // MARK: - private method
  
  
  // MARK: - internal method
  
  func connect(url: URL) async {
    self.socketTask = self.urlSession.webSocketTask(with: url)
    self.socketTask?.resume()
    
    print("common socket connected")
  }
  
  func receive() async {
    while true {
      if let message = try? await socketTask?.receive() {
        switch message {
          case .string(let text):
            DispatchQueue.global().async {
              self.message = text
            }
          case .data:
            continue
          @unknown default:
            fatalError()
        }
      } else {
        break
      }
    }
  }
  
  func disconnect() async {
    self.socketTask?.cancel()
  }
  
  func notifyDelegate(message: String) {
    Task {
      self.delegate?.didReceiveMessage(message)
    }
  }
  
  func setDelegate(_ newDelegate: CommonSocketConnectorDelegate?) async  {
    self.delegate = newDelegate
  }

}

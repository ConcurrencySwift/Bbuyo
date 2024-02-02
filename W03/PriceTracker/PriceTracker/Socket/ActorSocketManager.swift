//
//  SocketConnector.swift
//  PriceTracker
//
//  Created by 송하민 on 2/1/24.
//

import Foundation

protocol ActorSocketConnectorDelegate: AnyObject {
  func didReceiveMessage(_ message: String)
}

actor ActorSocketConnector: AsyncSocketProtocol {
  
  // MARK: - private properties
  
  private var socketTask: URLSessionWebSocketTask?
  private let urlSession = URLSession(configuration: .default)
  
  
  // MARK: - properties

  weak var delegate: ActorSocketConnectorDelegate?
  
  var message: String? {
    didSet {
      guard let message else { return }
      notifyDelegate(message: message)
    }
  }
  
  
  // MARK: - life cycle

  
  // MARK: - private method
  
  
  // MARK: - internal method
  
  func connect(url: URL) async {
    self.socketTask = self.urlSession.webSocketTask(with: url)
    self.socketTask?.resume()
    
    print("actor socket connected")
  }
  
  func receive() async {
    while true {
      if let message = try? await socketTask?.receive() {
        switch message {
          case .string(let text):
            self.message = text
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
    Task { @MainActor in
      await self.delegate?.didReceiveMessage(message)
    }
  }
  
  func setDelegate(_ newDelegate: ActorSocketConnectorDelegate?) async  {
    self.delegate = newDelegate
  }

}

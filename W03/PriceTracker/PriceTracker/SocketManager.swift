//
//  SocketManager.swift
//  PriceTracker
//
//  Created by 송하민 on 2/1/24.
//

import Foundation

protocol SocketProtocol {
  func connect(url: URL)
  func receive() async
  func send()
  func disconnect()
}

class SocketManager: SocketProtocol {

  
  // MARK: - private properties
  
  private var socketTask: URLSessionWebSocketTask?
  private let urlSession = URLSession(configuration: .default)
  
  
  // MARK: - internal properties
  
  static var shared: SocketManager = SocketManager()
  
  
  // MARK: - life cycle
  
  private init() { }
  
  
  
  // MARK: - private method
  
  
  // MARK: - internal method
  
  func connect(url: URL) {
    self.socketTask = self.urlSession.webSocketTask(with: url)
    self.socketTask?.resume()
    
    Task { 
      await self.receive()
    }
  }
  
  func receive() async {
    while let message = try? await socketTask?.receive() {
      switch message {
        case .string(let text):
          print("Received text message: \(text)")
        case .data(let data):
          print("Received data message: \(data)")
        @unknown default:
          fatalError("Unknown message type")
      }
    }
  }

  func send() {
    
  }
  
  func disconnect() {
    self.socketTask?.cancel()
  }
  
  
}

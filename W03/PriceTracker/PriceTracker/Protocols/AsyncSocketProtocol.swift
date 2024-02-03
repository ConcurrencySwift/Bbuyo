//
//  SocketProtocol.swift
//  PriceTracker
//
//  Created by 송하민 on 2/3/24.
//

import Foundation

protocol AsyncSocketProtocol {
  func connect(url: URL) async
  func receive() async
  func disconnect() async
}

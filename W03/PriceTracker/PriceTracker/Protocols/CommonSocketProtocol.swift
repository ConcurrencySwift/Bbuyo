//
//  CommonSocketProtocol.swift
//  PriceTracker
//
//  Created by 송하민 on 2/3/24.
//

import Foundation

protocol CommonSocketProtocol {
  func connect(url: URL)
  func receive()
  func disconnect()
}

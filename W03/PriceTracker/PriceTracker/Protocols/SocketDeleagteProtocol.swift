//
//  SocketDeleagteProtocol.swift
//  PriceTracker
//
//  Created by 송하민 on 2/3/24.
//

import Foundation

protocol SocketDeleagteProtocol {
  associatedtype DelegateType
  func setDelegate(_ newDelegate: DelegateType?) async
}

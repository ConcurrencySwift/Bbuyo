//
//  ViewController.swift
//  PriceTracker
//
//  Created by 송하민 on 2/1/24.
//

import UIKit

class ViewController: UIViewController {

  
  
  
  // MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    SocketManager.shared.connect(url: URL(string: "ws://localhost:3001")!)
  }


}


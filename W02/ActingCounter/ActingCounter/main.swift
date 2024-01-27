//
//  main.swift
//  ActingCounter
//
//  Created by 송하민 on 1/27/24.
//

import Foundation

actor Counter {
  private var value: Int = 0
  
  func getValue() -> Int {
    return value
  }
  
  func increment() {
    value += 1
  }
}

let counter = Counter()

let group = DispatchGroup()
for _ in 0..<1000 {
  DispatchQueue.global().async(group: group) {
    Task {
      await counter.increment()
    }
  }
}

group.notify(queue: .main) {
  Task {
    let finalCount = await counter.getValue()
    print("Final count is \(finalCount)")
  }
}

RunLoop.main.run()

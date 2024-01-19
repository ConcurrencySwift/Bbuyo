//
//  UIViewExtension.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import UIKit
import SnapKit

extension UIView {
  
  func setSnpLayout(baseView: UIView, _ closure: (_ make: ConstraintMaker) -> Void) {
    baseView.addSubview(self)
    self.snp.makeConstraints(closure)
  }
}

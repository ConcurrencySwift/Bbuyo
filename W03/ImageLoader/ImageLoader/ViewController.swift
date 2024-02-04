//
//  ViewController.swift
//  ImageLoader
//
//  Created by 송하민 on 2/4/24.
//

import UIKit
import Then
import SnapKit
import SwiftyJSON

class ViewController: UIViewController {
  
  private let baseView = UIView()
  
  private let scrollView = UIScrollView()
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.backgroundColor = .white
  }
  

  // MARK: - properties
  
  private let imageDownloader = ImageDownloader()
  
  private var imageURLs: [URL]? {
    return self.loadImageURLs()
  }
  
  // MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  
//    self.loadImagesAtOnce()
    self.loadImagesImmediately()
  }
  
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - private method
  
  private func setup() {
    self.view.addSubview(self.baseView)
    self.baseView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.baseView.addSubview(self.scrollView)
    self.scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.scrollView.addSubview(self.stackView)
    self.stackView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.width.equalToSuperview()
      make.bottom.equalToSuperview().priority(.low)
    }
  }
  
  private func loadImageURLs() -> [URL]? {
    guard let path = Bundle.main.path(forResource: "ImagesInfo", ofType: "json") else {
      return nil
    }
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      guard let photos = try JSON(data: data)["photos"].array else { return nil }
      let returnURLs: [URL] = {
        return photos.map { URL(string: $0["src"]["original"].stringValue)! }
      }()
      return returnURLs
    } catch {
      return nil
    }
  }
  
  private func loadImagesAtOnce() {
    Task {
      let imageViews = await self.imageDownloader.downloadImages(from: self.imageURLs ?? [])
      imageViews.forEach { image in
        let imageView = UIImageView(image: image)
        self.stackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
          make.width.equalToSuperview()
          make.height.equalTo(300)
        }
      }
    }
  }
  
  private func loadImagesImmediately() {
    Task {
      await withTaskGroup(of: UIImage?.self) { group in
        for url in self.imageURLs ?? [] {
          group.addTask { [weak self] in
            await self?.imageDownloader.downloadImage(from: url)
          }
        }
        
        for await image in group {
          DispatchQueue.main.async { [weak self] in
            guard let image = image else { return }
            let imageView = UIImageView(image: image)
            self?.stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
              make.width.equalToSuperview()
              make.height.equalTo(300)
            }
          }
        }
      }
    }
  }

  
}


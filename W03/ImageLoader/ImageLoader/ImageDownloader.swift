//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by 송하민 on 2/4/24.
//

import UIKit

final class ImageDownloader {
  
  func downloadImage(from url: URL) async -> UIImage? {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      return UIImage(data: data)
    } catch {
      print("Error downloading image: \(error)")
      return nil
    }
  }
  
  func downloadImages(from urls: [URL]) async -> [UIImage] {
    var images: [UIImage] = []
    
    await withTaskGroup(of: UIImage?.self) { group in
      for url in urls {
        group.addTask {
          return await self.downloadImage(from: url)
        }
      }
      for await image in group where image != nil {
        images.append(image!)
      }
    }
    return images
  }
}

//
//  ImageService.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 28/04/2023.
//

import Foundation
import UIKit

protocol ImageServiceType {
    func retrieveImage(url: String, completion: @escaping ((UIImage) -> Void))
}

// Image service to download asynchronously images from string url.
final class ImageService: ImageServiceType {
    func retrieveImage(url: String, completion: @escaping ((UIImage) -> Void)) {
        print(url)
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print("Failed to download image data: \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    print("Failed to create UIImage")
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
    }
}

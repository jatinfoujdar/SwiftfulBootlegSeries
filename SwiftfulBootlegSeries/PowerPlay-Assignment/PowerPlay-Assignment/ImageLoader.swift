//
//  ImageLoader.swift
//  PowerPlay-Assignment
//
//  Created by jatint on 24/09/25.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
        cache.countLimit = 200
        cache.totalCostLimit = 50 * 1024 * 1024 
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        let nsURL = url as NSURL
        if let cached = cache.object(forKey: nsURL) {
            completion(cached)
            return nil
        }
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self.cache.setObject(image, forKey: nsURL, cost: data.count)
            DispatchQueue.main.async { completion(image) }
        }
        task.resume()
        return task
    }
}



//
//  ImageLoader.swift
//  Gameway
//
//  Created by Luis Genesius on 12/02/22.
//

import Foundation
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

final class ImageLoader {
    private var imageCache = _imageCache
    
    func loadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        let urlString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(imageFromCache)
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

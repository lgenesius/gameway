//
//  ImageCacheType.swift
//  Gameway
//
//  Created by Luis Genesius on 14/02/22.
//

import Foundation
import UIKit

protocol ImageCacheType {
    // returns the image associated with a given url
    func image(for url: URL) -> UIImage?
    
    // inserts the image for specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    
    // removes the image of the specified url in the cache
    func removeImage(for url: URL)
    
    // removes all images from the cache
    func removeAllImages()
    
    // accesses the value associated with the given key for reading and writing
    subscript(_ key: URL) -> UIImage? { get set }
}

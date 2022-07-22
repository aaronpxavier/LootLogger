//
//  ImageStore.swift
//  LootLogger
//
//  Created by ladmin on 7/22/22.
//

import Foundation
import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        let url = imageURL(forKey: key)
        if let data = image.jpegData(compressionQuality: 0.5) {
            try? data.write(to: url)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        if let cachedImage = cache.object(forKey: key as NSString) {
            return cachedImage
        } else if let imageFromDisk = UIImage(contentsOfFile: imageURL(forKey: key).path) {
            return imageFromDisk
        }
        return nil
    }
    
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
}


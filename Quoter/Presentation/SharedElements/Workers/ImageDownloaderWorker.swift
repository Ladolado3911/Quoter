//
//  ImageDownloader.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

class ImageDownloaderWorker {
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                completion(image)
            }
        }
        catch {
            print(error)
        }
    }
    
    static func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                completion(image)
            }
        }
        catch {
            print(error)
        }
    }
}
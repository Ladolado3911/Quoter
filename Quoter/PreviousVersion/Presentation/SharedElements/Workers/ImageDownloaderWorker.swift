//
//  ImageDownloader.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

class ImageDownloaderWorker {
    
    static func downloadImage(queue: DispatchQueue, urlString: String, urlIndex: Int, completion: @escaping ((UIImage?, Int)) -> Void) {
        queue.async {
            guard let url = URL(string: urlString) else { return }
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    completion((image, urlIndex))
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let queue = DispatchQueue(label: "image", qos: .background, attributes: .concurrent)
        queue.async {
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
    
    static func downloadImages(urls: [String?], completion: @escaping ([UIImage?]) -> Void) {
        let group = DispatchGroup()
        var resultImages: [UIImage?] = []
        var tempDict: [UIImage?: Int] = [:]
        let queue = DispatchQueue(label: "image", qos: .background, attributes: .concurrent)
        for urlNum in 0..<urls.count {
            if let url = urls[urlNum] {
                group.enter()
                downloadImage(queue: queue, urlString: url, urlIndex: urlNum) { tuple in
                    //resultImages.append(image)
                    tempDict[tuple.0] = tuple.1
                    //resultImages.insert(tuple.0, at: tuple.1)
                    group.leave()
                }
//                downloadImage(urlString: url) { image in
//                    resultImages.append(image)
//                    group.leave()
//
//                }
            }
        }
        group.notify(queue: .main) {
            resultImages = (tempDict.sorted { $0.1 < $1.1 }).map { $0.key }
            
            completion(resultImages)
        }
    }
}
